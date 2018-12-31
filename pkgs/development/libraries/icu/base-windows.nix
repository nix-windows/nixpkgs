{ version, sha256, patches ? [], patchFlags ? "" }:
{ stdenv, fetchurl }:

let
  pname = "icu4c";

  baseAttrs = {
    src = fetchurl {
      url = "http://download.icu-project.org/files/${pname}/${version}/${pname}-"
        + (stdenv.lib.replaceChars ["."] ["_"] version) + "-src.zip"; # tgz lacks some files https://sourceforge.net/p/icu/mailman/icu-support/thread/bb731159-667b-8393-b754-f7043597b374%40dundee.ac.uk/
      inherit sha256;
    };

    postUnpack = ''
      $ENV{sourceRoot} = "$ENV{sourceRoot}/source";
      print("Source root reset to $ENV{sourceRoot}\n");
    '';

    postPatch = ''
      sub process {
        my $filename = $_;
        return unless $filename =~ /\.vcxproj$/;
        changeFile {
          s|ToolsVersion="[^"]+"|ToolsVersion="${stdenv.cc.msbuild.version}"|g;
          s|<PlatformToolset>v140</PlatformToolset>|<PlatformToolset>v141</PlatformToolset>|g;
          s|(<PropertyGroup Label="Globals">)|$1<WindowsTargetPlatformVersion>${stdenv.cc.sdk.version}</WindowsTargetPlatformVersion>|g unless /WindowsTargetPlatformVersion/;
          s|<WindowsTargetPlatformVersion>[^<]+<|<WindowsTargetPlatformVersion>${stdenv.cc.sdk.version}<|g;
          $_
        } $filename;
      }
      find({ wanted => \&process, no_chdir => 1}, '.');

      changeFile {
          s|Project[^\n]+_uwp.+?EndProject||sgr;     # do not build UWP targets (currently we do not have UWP SDK here)
      } 'allinone/allinone.sln';
    '';

    inherit patchFlags patches;

    buildPhase = ''
      system('msbuild allinone\allinone.sln /p:Configuration=Release /p:Platform=x64') == 0 or die;
    '';

    installPhase = ''
      make_path($ENV{out})                       or die "make_path($ENV{out}): $!";
      dircopy('../bin64',   "$ENV{out}/bin")     or die "dircopy(../bin64,   $ENV{out}/bin): $!";
      dircopy('../lib64',   "$ENV{out}/lib")     or die "dircopy(../lib64,   $ENV{out}/lib): $!";
      dircopy('../include', "$ENV{out}/include") or die "dircopy(../include, $ENV{out}/include): $!";
    '';

    meta = with stdenv.lib; {
      description = "Unicode and globalization support library";
      homepage = http://site.icu-project.org/;
      maintainers = with maintainers; [ raskin ];
      platforms = platforms.all;
    };
  };

  realAttrs = baseAttrs // {
    name = pname + "-" + version;
  };

  attrs = realAttrs;
in
stdenv.mkDerivation attrs
