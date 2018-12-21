# This function downloads and unpacks an archive file, such as a zip
# or tar file. This is primarily useful for dynamically generated
# archives, such as GitHub's /archive URLs, where the unpacked content
# of the zip file doesn't change, but the zip file itself may
# (e.g. due to minor changes in the compression algorithm, or changes
# in timestamps).

{ lib, stdenv, fetchurl, unzip }:

{ # Optionally move the contents of the unpacked tree up one level.
  stripRoot ? true
, url
, extraPostFetch ? ""
, name ? "source"
, ... } @ args:

if lib.hasSuffix "perl" stdenv.shell || lib.hasSuffix "perl.exe" stdenv.shell then

# unpackFile() uses 7z.exe (which is part of stdenvNoCC) so it can handle .zip files without pkgs.unzip
(fetchurl ({
  inherit name;

  recursiveHash = true;

  downloadToTemp = true;

  postFetch = ''
    my $unpackDir = "$ENV{TMPDIR}/unpack";
    mkdir($unpackDir) or die "mkdir: $!";
    chdir($unpackDir) or die "chdir: $!";

    my $renamed="$ENV{TMPDIR}/${baseNameOf url}";
    move($ENV{downloadedFile}, $renamed) or die "move: $!";
    unpackFile($renamed);
  ''
  + (if stripRoot then ''
      my @ls = grep { $_ !~ /\/pax_global_header$/ } glob("$unpackDir/*");
      print("ls=".(join ' ', @ls)."\n");
      if (@ls != 1) {
        print("error: zip file must contain a single file or directory.\n");
        print("hint: Pass stripRoot=false; to fetchzip to assume flat list of files.\n");
        exit(1);
      }
      my $fn = shift @ls;
      if (-f $fn) {
        mkdir($ENV{out}) or die $!;
        copy($fn, "$ENV{out}/") or die $!;
      } else {
        dircopy($fn, $ENV{out}) or die $!;
      }
    '' else ''
      dircopy($unpackDir, $ENV{out});
    '')
  + extraPostFetch;
} // removeAttrs args [ "stripRoot" "extraPostFetch" ]))

else

(fetchurl ({
  inherit name;

  recursiveHash = true;

  downloadToTemp = true;

  postFetch = ''
      unpackDir="$TMPDIR/unpack"
      mkdir "$unpackDir"
      cd "$unpackDir"

      renamed="$TMPDIR/${baseNameOf url}"
      mv "$downloadedFile" "$renamed"
      unpackFile "$renamed"
    ''
    + (if stripRoot then ''
      if [ $(ls "$unpackDir" | wc -l) != 1 ]; then
        echo "error: zip file must contain a single file or directory."
        echo "hint: Pass stripRoot=false; to fetchzip to assume flat list of files."
        exit 1
      fi
      fn=$(cd "$unpackDir" && echo *)
      if [ -f "$unpackDir/$fn" ]; then
        mkdir $out
      fi
      mv "$unpackDir/$fn" "$out"
    '' else ''
      mv "$unpackDir" "$out"
    '') #*/
    + extraPostFetch;
} // removeAttrs args [ "stripRoot" "extraPostFetch" ])).overrideAttrs (x: {
  # Hackety-hack: we actually need unzip hooks, too
  nativeBuildInputs = x.nativeBuildInputs ++ [ unzip ];
})
