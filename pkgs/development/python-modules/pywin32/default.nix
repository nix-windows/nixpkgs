{ stdenv, lib, python, setuptools, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "pywin32";
  version = "224";
  format = "other";

  src = fetchFromGitHub {
    owner = "mhammond";
    repo = "pywin32";
    rev = "b${version}";
    sha256 = "1v9ld6ya3l4i8r5q2dqaf9188pcd2h4nyc564miq7ly7wh2dc7ba";
  };

# buildInputs = [cython setuptools-git];
# propagatedBuildInputs = [freetds];

# # The tests require a running instance of SQLServer, so we skip them
# doCheck = false;
#    copy '${./setup.py}', 'setup.py';

  postPatch = ''
    # We know where python.dll is, no need for heuristic search
    changeFile { s|\Q"%s\\%s\\%s"), app_dir, py_dll_candidates[i]\E|"${ builtins.replaceStrings [''/'' ''\''] [''\\\\'' ''\\\\''] "${python}/bin/%s"}")|gr    } 'Pythonwin\Win32uiHostGlue.h';

    # This symbol is not defined in modern SDK
    changeFile { s|\Q#define JOB_OBJECT_RESERVED_LIMIT_VALID_FLAGS JOB_OBJECT_RESERVED_LIMIT_VALID_FLAGS||gr } 'win32\src\win32job.i';

    # Do not build manifests
    changeFile { s|\Qself._want_assembly_kept = \E|self._want_assembly_kept = False and |gr                  } 'setup.py';

    # Do not build COM extention (extra headers needed for MS Exchange, etc)
    changeFile { s|\Qcom_extensions += [\E|com_extensions2 = [|gr                                            } 'setup.py';
    # axscript.lib is not produced, so do not fail trying to copy it
    changeFile { s|\Q['win32com', 'axscript%s.lib']\E||gr                                                    } 'setup.py';

    # Do not copy MFC dll's (it crashes trying to find them in registry)
    changeFile { s|(\Qtarget_dir = os.path.join(self.build_lib, "pythonwin")\E)|\1; return|gr                } 'setup.py';

    # Wrong hack to avoid link.exe failure, need to investigate more
    changeFile { s|(\Qif not tokens[0][0] in string.ascii_letters\E)|\1 or tokens[-1] == 'PRIVATE'|gr        } 'setup.py';

    # No need to register COM objects
    writeFile 'pywin32_postinstall.py', '#';
  '';

  buildPhase = ''
    $ENV{PYTHONPATH} = "${setuptools}/${python.sitePackages};$ENV{PYTHONPATH}";  # TODO: some hook should handle this
    $ENV{INCLUDE} = "${python}/include";                                         # TODO: some hook should handle this

    $ENV{MSSDK_INCLUDE} = '${stdenv.cc.msvc}/include'; # do not let setup.py to read registry
    $ENV{MSSDK_LIB}     = '${stdenv.cc.msvc}/lib';

    system("${python.interpreter} setup.py install --prefix=$ENV{out}") == 0 or die;
  '';

  postInstall = ''
    # ActivePython puts these files (and also msvcp140.dll and vcruntime140.dll) next to python.exe, let's do the same
    make_path "$ENV{out}/bin";
    for my $file (glob("$ENV{out}/${python.sitePackages}/pywin32_system32/*.dll"),
                       "$ENV{out}/${python.sitePackages}/win32/pythonservice.exe") {
        move($file, "$ENV{out}/bin/") or die "move($file): $!";
    }

    copy('${stdenv.cc.redist}/x64/Microsoft.VC141.MFC/mfc140.dll', "$ENV{out}/${python.sitePackages}/pythonwin") or die "copy(mfc140.dll): $!";
  '';

  meta = with lib; {
    homepage = https://pypi.org/project/pywin32/;
  };
}
