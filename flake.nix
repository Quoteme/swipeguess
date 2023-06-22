{
  description = "swipeguess";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/flake-utils";
    };
    swipeGuessSrc = {
      url = "https://git.sr.ht/~earboxer/swipeGuess/archive/v0.2.1.tar.gz";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        defaultApp = apps.swipeGuess;
        defaultPackage = packages.swipeGuess;
        apps.swipeGuess = {
          type = "app";
          program = "${packages.swipeGuess}/bin/swipeGuess";
        };
        packages.swipeGuess = pkgs.stdenv.mkDerivation {
          name = "swipeGuess";
          pname = "swipeGuess";
          version = "0.2.0";
          src = inputs.swipeGuessSrc;
          buildInputs = [ ];
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/bin
            gcc -o $out/bin/swipeGuess $src/swipeGuess.c
            chmod +x $out/bin/swipeGuess
          '';
        };
      }
    );
}
