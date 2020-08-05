{ lib }:

rec {
  features = {
    default        = [ ];
    # Intel
    westmere       = [ "sse3" "ssse3" "sse4_1" "sse4_2"                                                  ];
    sandybridge    = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx"                              ];
    ivybridge      = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx"                              ];
    haswell        = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2"          "fma"        ];
    broadwell      = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2"          "fma"        ];
    skylake        = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2"          "fma"        ];
    skylake-avx512 = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx" "avx2" "avx512" "fma"        ];
    # AMD
    btver1         = [ "sse3" "ssse3" "sse4_1" "sse4_2"                                                  ];
    btver2         = [ "sse3" "ssse3" "sse4_1" "sse4_2"         "aes" "avx"                              ];
    bdver1         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx"                 "fma" "fma4" ];
    bdver2         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx"                 "fma" "fma4" ];
    bdver3         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx"                 "fma" "fma4" ];
    bdver4         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx" "avx2"          "fma" "fma4" ];
    znver1         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx" "avx2"          "fma"        ];
    znver2         = [ "sse3" "ssse3" "sse4_1" "sse4_2" "sse4a" "aes" "avx" "avx2"          "fma"        ];
  };
  # a superior CPU has all the features of an inferion one and is able to build and test code for it
  inferiors = {
    # Intel
    default        = [ ];
    westmere       = [ ];
    sandybridge    = [ "westmere" ];
    ivybridge      = [ "westmere" "sandybridge" ];
    haswell        = [ "westmere" "sandybridge" "ivybridge" ];
    broadwell      = [ "westmere" "sandybridge" "ivybridge" "haswell" ];
    skylake        = [ "westmere" "sandybridge" "ivybridge" "haswell" "broadwell" ];
    skylake-avx512 = [ "westmere" "sandybridge" "ivybridge" "haswell" "broadwell" "skylake" ];
    # AMD
    btver1         = [ ];
    btver2         = [ ];
    bdver1         = [ ];
    bdver2         = [ ];
    bdver3         = [ ];
    bdver4         = [ ];
    znver1         = [ ];
    znver2         = [ ];
  };

  predicates = {
    sse3Support    = x: builtins.elem "sse3"   features.${x};
    ssse3Support   = x: builtins.elem "ssse3"  features.${x};
    sse4_1Support  = x: builtins.elem "sse4_1" features.${x};
    sse4_2Support  = x: builtins.elem "sse4_2" features.${x};
    sse4_aSupport  = x: builtins.elem "sse4a"  features.${x};
    avxSupport     = x: builtins.elem "avx"    features.${x};
    avx2Support    = x: builtins.elem "avx2"   features.${x};
    avx512Support  = x: builtins.elem "avx512" features.${x};
    aesSupport     = x: builtins.elem "aes"    features.${x};
    fmaSupport     = x: builtins.elem "fma"    features.${x};
    fma4Support    = x: builtins.elem "fma4"   features.${x};
  };
}
