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
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.kubectl
            pkgs.yq-go
            pkgs.bats
            pkgs.shellcheck
            pkgs.bump-my-version
            pkgs.go-task
          ];

          shellHook = ''
            mkdir -p test/test_helper
            ln -sfn ${bats-support} test/test_helper/bats-support
            ln -sfn ${bats-assert} test/test_helper/bats-assert
          '';
        };
      });
}
