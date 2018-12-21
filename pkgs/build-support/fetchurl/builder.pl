require "$ENV{stdenv}/setup.pm";
require "$ENV{mirrorsFile}";

my $curlVersion = `curl -V` =~ s/^curl ([0-9.]+).+/\1/sr;

die "curl not found on PATH '$ENV{PATH}'" if !$curlVersion;


# Curl flags to handle redirects, not use EPSV, handle cookies for
# servers to need them during redirects, and work on SSL without a
# certificate (this isn't a security problem because we check the
# cryptographic hash of the output anyway).
#$ENV{PATH}="C:\\Git\\mingw64\\bin;$ENV{PATH}";
my @curl = (
    'curl',
    '--location',
    '--max-redirs', '20',
    '--retry', '3',
    '--disable-epsv',
    '--cookie-jar', 'cookies',
    '--insecure',
    '--user-agent', "curl/$curlVersion Nixpkgs/$ENV{nixpkgsVersion}",
    (split / /, $ENV{curlOpts}),
    (split / /, $ENV{NIX_CURL_FLAGS})
);

$ENV{downloadedFile} = $ENV{out};
$ENV{downloadedFile} = "$ENV{TMPDIR}/file" if $ENV{downloadToTemp};

sub tryDownload {
    my $url = shift;
    print("\ntrying $url\n");
    my $curlexit = 18;

    # if we get error code 18, resume partial download
    while ($curlexit == 18) {
       # keep this inside an if statement, since on failure it doesn't abort the script
       my @cmd = (@curl, '-C', '-', '--fail', $url, '--output', $ENV{downloadedFile});
       print(join ' ', @cmd);
       return 0 if system(@curl, '-C', '-', '--fail', $url, '--output', $ENV{downloadedFile}) == 0;
       $curlexit = $? >> 8;
    }
    return $curlexit;
}


sub finish() {
    chmod($downloadedFile, 555) if ($^O ne 'MSWin32') && $ENV{executable} eq "1";
    runHook('postFetch');
    exit(0);
}

# do not expect Windows packages on tarballs.nixos.org
sub tryHashedMirrors() {
    my $hashedMirrors = $ENV{NIX_HASHED_MIRRORS};

    for my $mirror (split / /, $hashedMirrors) {
        my $url = "$mirror/$outputHashAlgo/$outputHash";
        my @cmd = (@curl, '--retry', '0',
                          '--connect-timeout', $ENV{NIX_CONNECT_TIMEOUT} ? $ENV{NIX_CONNECT_TIMEOUT} : '15',
                          '--fail',
                          '--silent',
                          '--show-error',
                          '--head',
                          $url,
                          '--write-out', '%{http_code}',
                          '--output', $^O eq 'MSWin32' ? 'nul' : '/dev/null');
        print(join ' ', @cmd);
        if (system(@cmd) == 0) {
            finish() if tryDownload($url) == 0;
        }
    }
}


my @urls2 = ();
for my $url (split / /, $ENV{urls}) {
    if ($url =~ /^mirror:\/\/([a-z0-9]+)(\/.+)/) {
        my $site = $1;
        my $filename = $2;
        warn "unknown mirror:// site $site; not in mirrorsFile $ENV{mirrorsFile}" unless defined $mirrors{$site};
        my @mirrorlist = @{$mirrors{$site}};
        # Allow command-line override by setting NIX_MIRRORS_$site.
        @mirrorlist = split / /, $ENV{"NIX_MIRRORS_$site"} if $ENV{"NIX_MIRRORS_$site"};
        for my $mirror (@mirrorlist) {
            push @urls2, "$mirror$filename";
        }
    } else {
        push @urls2, $url;
    }
}

if ($ENV{showURLs}) {
    open(my $fh, ">$out") or die "$!";
    print $fh (join ' ', @urls2)."\n";
    close($fh);
    exit(0);
}

tryHashedMirrors() if $ENV{preferHashedMirrors};

for my $url (@urls2) {
    finish() if tryDownload($url) == 0;
}

tryHashedMirrors() unless $ENV{preferHashedMirrors};

die "error: cannot download $ENV{name} from any mirror (" . (join ' ', @urls2) . ")";

