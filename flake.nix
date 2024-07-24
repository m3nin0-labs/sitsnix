{
  description = "A Nix-flake-based sits development environment";

    inputs = {
        nixgl.url = "github:nix-community/nixGL";
        nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    };

  outputs = { self, nixpkgs, nixgl }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default nixgl.overlay ]; };
      });
    in
    {
      overlays.default = final: prev: rec {
        rEnv = final.rWrapper.override {
          packages = with final.rPackages; [
            sits

            yaml
            dplyr
            gdalUtilities
            lubridate
            purrr
            Rcpp
            rstac
            sf
            showtext
            sysfonts
            slider
            terra
            tibble
            tidyr
            torch

            aws_s3
            caret
            cli
            covr
            dendextend
            dtwclust
            DiagrammeR
            digest
            e1071
            exactextractr
            FNN
            future
            gdalcubes
            geojsonsf
            ggplot2
            httr
            jsonlite
            kohonen
            leafem
            leaflet
            luz
            mgcv
            nnet
            openxlsx
            randomForest
            randomForestExplainer
            RColorBrewer
            RcppArmadillo
            scales
            spdep
            stars
            stringr
            supercells
            testthat
            tmap
            torchopt
            xgboost
            ];
        };
      };

      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs;
            [
              rEnv
              pandoc
              gdal
              rstudio
              texlive.combined.scheme-full
              pkgs.nixgl.auto.nixGLDefault
            ];
        };
      });
    };
}