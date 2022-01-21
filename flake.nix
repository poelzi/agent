{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  #inputs.buildpackage.url = "github:serokell/nix-npm-buildpackage";
  inputs.npmlock2nix = {
      url = "github:nix-community/npmlock2nix/master";
      flake = false;
    };

  outputs = { self, nixpkgs, flake-utils, npmlock2nix }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pname = "uhk-agent";
          version = "1.5.16";
          pkgs = nixpkgs.legacyPackages.${system};
          name = "${pname}-${version}";
          src = ./.;
        in let
          mynode = pkgs.nodejs-16_x;
          nodeEnv = (import npmlock2nix {
            pkgs = nixpkgs.legacyPackages.${system};
          });
        in let
          kboot = nodeEnv.node_modules {
            src = ./packages/uhk-common;
            nodejs = mynode;
            # installPhase = "cp -r . $out";
          };

        in
        {
           packages.uhk-agent = nodeEnv.build {
            node_modules_attrs = {
              buildInputs = with pkgs; [
                  electron_16
                  phantomjs2
                  python3
                  pkg-config
                  libusb
                  nodejs-16_x
                  # kboot
                ];

              ELECTRON_OVERRIDE_DIST_PATH = "${pkgs.electron_16}/bin";
              ELECTRON_SKIP_BINARY_DOWNLOAD=1;
            };
            src = ./.;
            
            nodejs = pkgs.nodejs-16_x;
            # npmBuild = ''
            #   ls -la
            #   ELECTRON_SKIP_BINARY_DOWNLOAD=1 npm run build'';
            patchPhase = ''
               sed -i '/.*lerna bootstrap.*/d' package.json
               cat package.json
               ls -la
               pwd
             '';


            buildCommands = [
              "ls -la"
              "ELECTRON_SKIP_BINARY_DOWNLOAD=1 npm run build" ];
            installPhase = "cp -r . $out";

              ELECTRON_OVERRIDE_DIST_PATH = "${pkgs.electron_16}/bin";
              ELECTRON_SKIP_BINARY_DOWNLOAD=1;
          };

          defaultPackage = self.packages.${system}.uhk-agent;
        }
        #   devShell = pkgs.mkShell {
        #     buildInputs = defaultDeps;
        #    };
        );
}