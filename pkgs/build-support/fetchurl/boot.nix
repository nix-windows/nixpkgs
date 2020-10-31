let mirrors = import ./mirrors.nix; in

{ system }:

{ url ? builtins.head urls
, urls ? [ url ]
, sha256
, name ? baseNameOf (toString url)
}:

import <nix/fetchurl.nix> {
  inherit system sha256 name;

  urls = builtins.concatMap (url:
            # Handle mirror:// URIs.
            let
              m = builtins.match "mirror://([a-z]+)/(.*)" url;
            in
              if m != null then
                map (mirror: mirror + (builtins.elemAt m 1)) mirrors.${builtins.elemAt m 0}
              else
                [url]
         ) urls;
# url = builtins.head urls;
}
