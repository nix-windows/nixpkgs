package Win32::Utils;

use 5.028_000;
use strict;
use warnings;

our $VERSION = '0.01';
require Exporter;
our @ISA=('Exporter');
our @EXPORT    = qw(readFile writeFile changeFile escapeWindowsArg dircopy readlink_f relsymlink uncsymlink symtree_reify symtree_link make_pathL remove_treeL findL);
our @EXPORT_OK = qw();

use Digest::file    qw(digest_file_hex);
use File::Basename  qw(dirname basename);
use Win32::LongPath qw(readlinkL testL symlinkL unlinkL renameL copyL mkdirL rmdirL openL attribL statL abspathL);

sub readFile {
    my $fh;
    my $path = shift;
    openL(\$fh, '<:encoding(UTF-8)', $path) or die "readFile($path) open: $!";
    binmode $fh; # do not emit \r
    local $/ = undef;
    my $content = <$fh>;
    close $fh;
    return $content;
}

sub writeFile {
    my ($filename, $content) = @_;
    make_pathL(dirname($filename)) or die "$!" unless -d dirname($filename);
    if (-e $filename) {
      attribL('-r', $filename) or die "writeFile($filename) attribL: $!";
      unlinkL($filename)       or die "writeFile($filename) unlinkL: $!" if -f $filename;
      rmdirL ($filename)       or die "writeFile($filename) rmdirL: $!"  if -d $filename;
    }
    my $fh;
    openL(\$fh, '>:encoding(UTF-8)', $filename) or die "writeFile($filename) open: $!";
    binmode $fh; # do not emit \r
    print $fh $content;
    close $fh;
}

sub changeFile (&@) {
    my $lambda = \&{shift @_};
    for my $filename (@_) {
        $_ = readFile($filename);
        writeFile($filename, $lambda->($_));
    }
}

sub escapeWindowsArg {
    my ($s) = @_;
    $s =~ s|\\$|\\\\|g;
    $s =~ s|\\"|\\\\"|g;
    $s =~ s|\"|\\"|g;
    return "\"$s\"";
}

#sub dircopy {
#    my ($from, $to) = @_;
#    my $logfile = "nul"; # "C:/tmp/robocopy-$$.log";
#    my $exitCode = system('robocopy', $from =~ s|/|\\|gr, $to =~ s|/|\\|gr, '/E', '/SL', "/LOG:$logfile") >> 8;
#    if ($exitCode == 0 || $exitCode == 1) { # success https://blogs.technet.microsoft.com/deploymentguys/2008/06/16/robocopy-exit-codes/
#        unlink($logfile);
#        return 1;
#    } else {
#        print("robocopy's exitCode=$exitCode logfile=$logfile\n");
#        return 0;
#    }
#}
# recursively copy directory
# there is no readymade method:
# xcopy's issue: paths longer than 254 chars
# robocopy's issue: it always tries to set attributes and timestamps on the copy which is not always possible due to insuficcient permission
sub dircopy {
    my $dirCopyInternal;
    $dirCopyInternal = sub {
        my ($from, $to) = @_;
        if (testL('l', $from)) {
#           print("dirCopyInternal($from, $to)L\n");
            my $target = readlinkL($from);
            # TODO: re-target symlink if not absolute?
            return symlinkL($target => $to);
        } elsif (-d $from) {
#           print("dirCopyInternal($from, $to)D\n");
            unless (-d $to) {
                return 0 unless mkdirL($to);
            }
            # avoid using glob() - at leaast it needs escaping spaces in the path
            my $dir = Win32::LongPath->new();
            return 0 unless $dir->opendirL($from);
            for my $f ($dir->readdirL()) {
                next if $f eq '.' || $f eq '..';
                return 0 unless &$dirCopyInternal("$from/$f", "$to/$f");
            }
            $dir->closedirL();
            return 1;
        } else {
#           print("dirCopyInternal($from, $to)F\n");
            return copyL($from, $to);
        }
    };
    my ($from, $to) = @_;
    unless (-d dirname($to)) {
        return 0 unless make_pathL(dirname($to));
    }
    return &$dirCopyInternal($from, $to);
}

sub readlink_f {
    my $src = shift;
    die "readlink_f: '$src' does not exist" unless -e $src;
    my %seen = ();
    while (testL('l', $src)) {
        $src = File::Spec->rel2abs(readlinkL($src), dirname($src));
        die "readlink_f($src): cycle" if $seen{$src};
        $seen{$src} = 1;
    }
    return $src;
}

sub relsymlink {
    my ($src, $tgt) = @_;
    $src = File::Spec->abs2rel(readlink_f($src), dirname($tgt));
    symlinkL($src => $tgt) or die "symlinkL($src => $tgt): $!";
}

sub uncsymlink {
    my ($src, $tgt) = @_;
    $src = readlink_f($src);
    $src =~ s|[/\\]+|\\|g;
    $src =  "\\\\?\\$src" if $src !~ /^\\/;
    $src =~ s/^(\\\\\?\\)([a-z])(:.+)$/$1.uc($2).$3/e;
    return symlinkL($src => $tgt);
}


 # make them comparable using `ne` and `eq`
sub _uniform_path {
    my $path = shift;
    $path =~ s|[\\/]+|/|g;
    $path =~ s/^([a-z])(:.+)$/uc($1).$2/e;
    return $path;
}

# symtree is like buildEnv, but
#  1. target might be not in nix store
#  2. target might be mutable (so can be used at sourceRoot)
#  2. other derivations/directories can be merged to any subfolder (not only root as in buildEnv)

# if $path exists: if it is reachable via symlink, make it real
# otherwise:       ensure dirname($path) is a directory, so a dir or file $path could be created
sub symtree_reify {
    my ($treeroot, $path, $cache) = @_;
    $treeroot = _uniform_path(File::Spec->rel2abs($treeroot)       ); # make them comparable using `ne` and `eq`
    $path     = _uniform_path(File::Spec->rel2abs($path, $treeroot)); # make them comparable using `ne` and `eq`
    $cache ||= {};

    return 1 if $cache->{$path}; # already reified

#   print("symtree_reify($treeroot, $path)\n");
    $path =~ /^\Q$treeroot\E([\/\\].+|)$/ or die "'$path' must be under '$treeroot'";

    symtree_reify($treeroot, dirname($path), $cache) if $treeroot ne $path; # reify parent dirs
#   die "not dir '".dirname(dirname($path))."'" unless          -d dirname(dirname($path));
#   die "symlink '".dirname(dirname($path))."'" unless !testL('l', dirname(dirname($path)));
    unless(-e dirname($path)) {
        return 0 unless mkdirL(dirname($path));
    }
    die "not dir '".dirname($path)."'" unless          -d dirname($path);
    die "symlink '".dirname($path)."'" unless !testL('l', dirname($path));

    if (-d $path) {
        if (testL('l', $path)) {
            my $target = readlinkL($path);
            -d $target or die "$target is not a dir";
            return 0 unless rmdirL($path) or die "$!";
            return 0 unless mkdirL($path) or die "$!";
            # populate dir with links to $target/*
            my $dir = Win32::LongPath->new();
            return 0 unless $dir->opendirL($target);
            for my $t ($dir->readdirL()) {
                next if $t eq '.' || $t eq '..';
                return 0 unless uncsymlink("$target/$t", "$path/$t");
            }
            $dir->closedirL();
        } else {
            # nothing to do
        }
    } elsif (-f $path) {
        if (testL('l', $path)) {
            my $target = readlinkL($path);
            -f $target or die "$target is not a file";
            return 0 unless attribL('-r', $path);
            return 0 unless unlinkL($path);
            return 0 unless copyL($target, $path);
        } else {
            # nothing to do
        }
    } else {
        die "wtf2 $path" if -e $path;
    }
    $cache->{$path} = 1;
}

# add a link to symlink tree
sub symtree_link {
    my ($treeroot, $from, $to, $cache) = @_;
    $treeroot = _uniform_path(File::Spec->rel2abs($treeroot)     ); # make them comparable using `ne` and `eq`
    $from     = _uniform_path($from                              ); # make them comparable using `ne` and `eq`
    $to       = _uniform_path(File::Spec->rel2abs($to, $treeroot)); # make them comparable using `ne` and `eq`
    $cache ||= {};

#   print("symtree_link($treeroot, $from, $to)\n");
    $to =~ /^\Q$treeroot\E([\/\\].+|)$/ or die "'$to' must be under '$treeroot'";

    if (! -e $to) {
        return 0 unless symtree_reify($treeroot, $to, $cache);
        die unless ! -e $to && -d dirname($to) && !testL('l', dirname($to));
        return uncsymlink($from => $to);
    } elsif (-d $from) {
        die unless -d $to;
        return 0 unless symtree_reify($treeroot, $to, $cache); #if testL('l', $to);
        die unless -d $to && !testL('l', $to);

        my $dir = Win32::LongPath->new();
        return 0 unless $dir->opendirL($from);
        for my $t ($dir->readdirL()) {
            next if $t eq '.' || $t eq '..';
            return 0 unless symtree_link($treeroot, "$from/$t", "$to/$t", $cache);
        }
        $dir->closedirL();
        return 1;
    } elsif (-f $from) {
        # the only way to merge files is linking to the same file
        die if !testL('l', $to);
        my $fromf = _uniform_path(readlink_f($from));
        my $tof   = _uniform_path(readlink_f($to  ));
        return 1 if                 $fromf             eq                 $tof;
        return 1 if digest_file_hex($fromf, 'SHA-256') eq digest_file_hex($tof, 'SHA-256');
        die "cannot merge files\n  $from ($fromf)\n  $to ($tof)";
    } else {
        die "$from does exist but not a directory";
    }
}

# recursively makes path
sub make_pathL {
    for my $path (@_) {
        my $parent = dirname($path);
        if ($parent ne $path) {
            unless (-d $parent) {
                return 0 unless make_pathL($parent);
            }
        }
        return 0 unless mkdirL($path);
    }
    return 1;
}

# remove tree not following symlinks
sub remove_treeL {
    for my $path (@_) {
        #print("remove_treeL($path)\n");
        if (-d $path) { # dir | symlink to dir
            if (!testL('l', $path)) {
                my $dir = Win32::LongPath->new();
                return 0 unless $dir->opendirL($path);
                for my $t ($dir->readdirL()) {
                    next if $t eq '.' || $t eq '..';
                    return 0 unless remove_treeL("$path/$t");
                }
                $dir->closedirL();
            }
            #print("rmdirL($path)\n");
            return 0 unless attribL('-r', $path);
            return 0 unless rmdirL($path);
        } else { # file | symlink to file | not exist
            #print("unlinkL($path)\n");
            return 0 unless attribL('-r', $path);
            return 0 unless unlinkL($path);
        }
    }
    return 1;
}

# find which does not follow symlinks-to-dir
sub findL (&@) {
    my $lambda = \&{shift @_};
    my $findInternal;
    $findInternal = sub {
        my $path = shift;
        $_ = $path; # so $lambda could use $_
        $lambda->($_);
        if (-d $path) { # dir | symlink to dir
            if (!testL('l', $path)) {
                my $dir = Win32::LongPath->new();
                return 0 unless $dir->opendirL($path);
                for my $t ($dir->readdirL()) {
                    next if $t eq '.' || $t eq '..';
                    return 0 unless &$findInternal("$path/$t");
                }
                $dir->closedirL();
            }
        }
        return 1;
    };
    for my $path (@_) {
      return 0 unless &$findInternal($path);
    }
    return 1;
}

1;