"""
Improved support for Microsoft Visual C++ compilers.

Known supported compilers:
--------------------------
Microsoft Visual C++ 9.0:
    Microsoft Visual C++ Compiler for Python 2.7 (x86, amd64)
    Microsoft Windows SDK 6.1 (x86, x64, ia64)
    Microsoft Windows SDK 7.0 (x86, x64, ia64)

Microsoft Visual C++ 10.0:
    Microsoft Windows SDK 7.1 (x86, x64, ia64)

Microsoft Visual C++ 14.0:
    Microsoft Visual C++ Build Tools 2015 (x86, x64, arm)
    Microsoft Visual Studio 2017 (x86, x64, arm, arm64)
    Microsoft Visual Studio Build Tools 2017 (x86, x64, arm, arm64)
"""

import os
import sys
import platform
import itertools
from setuptools.extern.packaging.version import LegacyVersion

from setuptools.extern.six.moves import filterfalse

from .monkey import get_unpatched

def msvc9_find_vcvarsall(version):
    return r'@@cc@@\VC\vcvarsall.bat'

def msvc9_query_vcvarsall(ver, arch='x86', *args, **kwargs):
    return EnvironmentInfo().return_env()

def msvc14_get_vc_env(plat_spec):
    return EnvironmentInfo().return_env()

def msvc14_gen_lib_options(*args, **kwargs):
    """
    Patched "distutils._msvccompiler.gen_lib_options" for fix
    compatibility between "numpy.distutils" and "distutils._msvccompiler"
    (for Numpy < 1.11.2)
    """
    if "numpy.distutils" in sys.modules:
        import numpy as np
        if LegacyVersion(np.__version__) < LegacyVersion('1.11.2'):
            return np.distutils.ccompiler.gen_lib_options(*args, **kwargs)
    return get_unpatched(msvc14_gen_lib_options)(*args, **kwargs)





class EnvironmentInfo:
    """
    Return environment variables for specified Microsoft Visual C++ version
    and platform : Lib, Include, Path and libpath.

    This function is compatible with Microsoft Visual C++ 9.0 to 14.0.

    Script created by analysing Microsoft environment configuration files like
    "vcvars[...].bat", "SetEnv.Cmd", "vcbuildtools.bat", ...

    Parameters
    ----------
    arch: str
        Target architecture.
    vc_ver: float
        Required Microsoft Visual C++ version. If not set, autodetect the last
        version.
    vc_min_ver: float
        Minimum Microsoft Visual C++ version.
    """

    # Variables and properties in this class use originals CamelCase variables
    # names from Microsoft source files for more easy comparaison.

#   def __init__(self, arch, vc_ver=None, vc_min_ver=0):
#       #self.pi = PlatformInfo(arch)
#       #self.ri = RegistryInfo(self.pi)
#       #self.si = SystemInfo(self.ri, vc_ver)
#
#       if self.vc_ver < vc_min_ver:
#           err = 'No suitable Microsoft Visual C++ version found'
#           raise distutils.errors.DistutilsPlatformError(err)

    @property
    def vc_ver(self):
        """
        Microsoft Visual C++ version.
        """
        return '@@msbuild-version@@'

    @property
    def VSTools(self):
        """
        Microsoft Visual Studio Tools
        """
        return []

    @property
    def VCIncludes(self):
        """
        Microsoft Visual C++ & Microsoft Foundation Class Includes
        """
        return [r'@@msvc@@\include', r'@@msvc@@\atlmfc\include']

    @property
    def VCLibraries(self):
        """
        Microsoft Visual C++ & Microsoft Foundation Class Libraries
        """
        return [r'@@msvc@@\lib\x64', r'@@msvc@@\atlmfc\lib\x64']

    @property
    def VCStoreRefs(self):
        """
        Microsoft Visual C++ store references Libraries
        """
        return [r'@@msvc@@\lib\x86\store\references']

    @property
    def VCTools(self):
        """
        Microsoft Visual C++ Tools
        """
        return [r'@@msvc@@\bin\HostX64\x64']

    @property
    def OSLibraries(self):
        """
        Microsoft Windows SDK Libraries
        """
        return [r'@@sdk@@\lib\@@sdk-version@@\um\x64']

    @property
    def OSIncludes(self):
        """
        Microsoft Windows SDK Include
        """
        return [r'@@sdk@@\include\@@sdk-version@@\shared',
                r'@@sdk@@\include\@@sdk-version@@\um',
                r'@@sdk@@\include\@@sdk-version@@\winrt',
                r'@@sdk@@\include\@@sdk-version@@\cppwinrt']

    @property
    def OSLibpath(self):
        """
        Microsoft Windows SDK Libraries Paths
        """
        return [r'@@sdk@@\UnionMetadata\@@sdk-version@@', r'@@sdk@@\References\@@sdk-version@@']

    @property
    def SdkTools(self):
        """
        Microsoft Windows SDK Tools
        """
        return [r'@@sdk@@\bin\@@sdk-version@@\x64', r'@@sdk@@\bin\x64']

    @property
    def SdkSetup(self):
        """
        Microsoft Windows SDK Setup
        """
        return []

    @property
    def FxTools(self):
        """
        Microsoft .NET Framework Tools
        """
        return []

    @property
    def NetFxSDKLibraries(self):
        """
        Microsoft .Net Framework SDK Libraries
        """
        return []

    @property
    def NetFxSDKIncludes(self):
        """
        Microsoft .Net Framework SDK Includes
        """
        return []

    @property
    def VsTDb(self):
        """
        Microsoft Visual Studio Team System Database
        """
        return []

    @property
    def MSBuild(self):
        """
        Microsoft Build Engine
        """
        return [r'@@msbuild-version@@\bin\@@msbuild@@',
                r'@@msbuild-version@@\bin\@@msbuild@@\Roslyn']

    @property
    def HTMLHelpWorkshop(self):
        """
        Microsoft HTML Help Workshop
        """
        return []

    @property
    def UCRTLibraries(self):
        """
        Microsoft Universal C Runtime SDK Libraries
        """
        return [r'@@sdk@@\lib\@@sdk-version@@\ucrt\x64']

    @property
    def UCRTIncludes(self):
        """
        Microsoft Universal C Runtime SDK Include
        """
        return [r'@@sdk@@\include\@@sdk-version@@\ucrt']

    @property
    def FSharp(self):
        """
        Microsoft Visual F#
        """
        return []

    @property
    def VCRuntimeRedist(self):
        """
        Microsoft Visual C++ runtime redistribuable dll
        """
        return ''

    def return_env(self, exists=True):
        """
        Return environment dict.

        Parameters
        ----------
        exists: bool
            It True, only return existing paths.
        """
        env = dict(
            include=os.pathsep.join(self.VCIncludes +
                                    self.OSIncludes +
                                    self.UCRTIncludes +
                                    self.NetFxSDKIncludes),
            lib=os.pathsep.join(   self.VCLibraries +
                                   self.OSLibraries +
                                   self.FxTools +
                                   self.UCRTLibraries +
                                   self.NetFxSDKLibraries),
            libpath=os.pathsep.join(   self.VCLibraries +
                                       self.FxTools +
                                       self.VCStoreRefs +
                                       self.OSLibpath),
            path=os.pathsep.join(   self.VCTools +
                                    self.VSTools +
                                    self.VsTDb +
                                    self.SdkTools +
                                    self.SdkSetup +
                                    self.FxTools +
                                    self.MSBuild +
                                    self.HTMLHelpWorkshop +
                                    self.FSharp),
        )
        #if self.vc_ver >= 14 and os.path.isfile(self.VCRuntimeRedist):
        #    env['py_vcruntime_redist'] = self.VCRuntimeRedist
        return env
