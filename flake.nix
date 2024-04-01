{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            # Nix tools
            alejandra
            nixd
          ];
        };
      };

      flake.keys = {
        pgp = {
          fallback = ./pgp/fallback.asc;
          yubikey.piv-agent = ./pgp/yubikey-15892608/piv-agent.asc;
        };

        ssh = {
          fallback = ./ssh/fallback.pub;
          yubikey.piv-agent.touch-policy = {
            always = ./ssh/yubikey-15892608/piv-agent/touch-policy/always.pub;
            cached = ./ssh/yubikey-15892608/piv-agent/touch-policy/cached.pub;
            never = ./ssh/yubikey-15892608/piv-agent/touch-policy/never.pub;
          };
        };
      };
    };
}
