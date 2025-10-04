{
  description = "A bash script that decodes Kubernetes secrets";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bats-support = {
      url = "github:bats-core/bats-support/v0.3.0";
      flake = false;
    };
    bats-assert = {
      url = "github:bats-core/bats-assert/v2.2.0";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, bats-support, bats-assert }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        version = "0.1.4";
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "kd";
          inherit version;

          src = ./.;

          nativeBuildInputs = [ pkgs.makeWrapper ];

          installPhase = ''
            runHook preInstall

            # Install the main script
            install -Dm755 $src/src/kd.sh $out/bin/kd

            # Install Zsh completion
            install -Dm644 $src/completion/_kd.zsh $out/share/zsh/site-functions/_kd

            wrapProgram $out/bin/kd \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.kubectl pkgs.yq-go ]}

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "A bash script that decodes Kubernetes secrets";
            homepage = "https://github.com/shini4i/kd";
            license = licenses.mit;
            maintainers = [ { name = "shini4i"; github = "shini4i"; } ];
            platforms = platforms.all;
          };
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.kubectl
            pkgs.yq-go
            pkgs.bats
          ];

          shellHook = ''
            mkdir -p test/test_helper
            ln -sfn ${bats-support} test/test_helper/bats-support
            ln -sfn ${bats-assert} test/test_helper/bats-assert
          '';
        };
      });
}
