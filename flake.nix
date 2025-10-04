{
  description = "A bash script that decodes Kubernetes secrets";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
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

            install -Dm755 $src/src/kd.sh $out/bin/kd

            wrapProgram $out/bin/kd \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.kubectl pkgs.yq ]}

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Kubernetes secrets Decoder";
            homepage = "https://github.com/shini4i/kd";
            license = licenses.mit;
            maintainers = [ { name = "shini4i"; github = "shini4i"; } ];
            platforms = platforms.all;
          };
        };
      });
}
