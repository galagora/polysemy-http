let
  niv = import ./nix/sources.nix;

  haskellNix = import niv.haskellNix {};
  nixpkgsSrc = haskellNix.sources.nixpkgs-2003;
  nixpkgsArgs = haskellNix.nixpkgsArgs;
  pkgs = import nixpkgsSrc nixpkgsArgs;

  set = pkgs.haskell-nix.cabalProject {
    src = pkgs.haskell-nix.haskellLib.cleanGit {
      name = "polysemy-http";
      src = ./packages/polysemy-http;
    };
    modules = [{
      # Make Cabal reinstallable
      # nonReinstallablePkgs = [ "rts" "ghc-heap" "ghc-prim" "integer-gmp" "integer-simple" "base" "deepseq" "array" "ghc-boot-th" "pretty" "template-haskell" "ghcjs-prim" "ghcjs-th" "ghc-boot" "ghc" "Win32" "array" "binary" "bytestring" "containers" "directory" "filepath" "ghc-boot" "ghc-compact" "ghc-prim" "hpc" "mtl" "parsec" "process" "text" "time" "transformers" "unix" "xhtml" "terminfo" ];
    }];
    compiler-nix-name = "ghc8102";
  };
in set.polysemy-http.components.library // {
  env = set.shellFor {
    packages = p: [ p.polysemy-http ];
    tools = {
      # stack = "unstable";
      cabal = "3.2.0.0";
    };
    withHoogle = true;
    exactDeps = false;
  };
  # inherit pkgs;
}
