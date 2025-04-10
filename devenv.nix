{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages =
    [
      pkgs.bash
      pkgs.coreutils
      pkgs.deno
      pkgs.dprint
      pkgs.flyctl
      pkgs.gcc
      pkgs.git
      pkgs.nixfmt-rfc-style
      pkgs.sql-formatter
      pkgs.sqlite
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin (
      with pkgs.darwin.apple_sdk;
      [
        frameworks.CoreFoundation
        frameworks.Security
        frameworks.System
        frameworks.SystemConfiguration
      ]
    );

  scripts.welds = {
    exec = ''
      set -e
      cargo bin welds $@
    '';
    description = "The `welds` executable for generating database models.";
    binary = "bash";
  };
  scripts.sqlx = {
    exec = ''
      set -e
      cargo bin sqlx $@
    '';
    description = "The `sqlx` executable for database migrations.";
    binary = "bash";
  };

  scripts.melos = {
    exec = ''
      set -e
      dart run melos $@
    '';
    description = "The `melos` executable for managing the workspace.";
    binary = "bash";
  };

  scripts.dart-format = {
    exec = ''
      set -e
      dart format -o show $@ | head -n -1
    '';
    description = "The `flutter format` executable for formatting the workspace.";
    binary = "bash";
  };

  devShells = forSystem systems (system: {
    default = pkgs.mkShell {
      packages = with pkgs; [
        # Flutter & Dart
        fvm
        flutter
        dart

        # Node.js/Deno ecosystem
        nodejs_22 # For general JS tooling if needed
        nodePackages.pnpm # Or yarn/npm
        deno

        # Utilities
        jq # JSON processing
        # Project specific tools (commented out Rust related)
        # pkgs.cargo-binstall
        # pkgs.cargo-run-bin
        # welds # Assuming this is from a custom source or overlay
        # sqlx-cli # Assuming this is from a custom source or overlay

        # Android (if needed for Flutter mobile)
        # android-studio
        # android-sdk
        # openjdk17

        # iOS (requires macOS)
        # xcbeautify

        # Formatting/Linting
        dprint
        # pkgs.rustup # Handled via fenix now if needed, or removed
      ];

      # Set environment variables
      env = {
        # ANDROID_SDK_ROOT = "$HOME/Library/Android/sdk"; # Example for macOS
        # PATH = "$PATH:$HOME/.pub-cache/bin"; # Add Dart global tools
      };

      # Shell Hooks (commands to run when entering the shell)
      shellHook = ''
        echo "Entering Verily Dev Shell..."
        # Set Flutter version
        fvm use
        # You might want to install deno dependencies here if using an import map
        # deno cache deps.ts # Or similar
        echo "Verily Dev Shell Ready."
      '';

      # Custom scripts available in the shell
      scripts = {
        # welds = {
        #   exec = ''
        #     cargo bin welds $@
        #   '';
        #   description = "The `welds` ORM CLI tool.";
        # };
        # sqlx = {
        #   exec = ''
        #     # Ensure the database URL is set if required by sqlx-cli
        #     # export DATABASE_URL=...
        #     cargo bin sqlx $@
        #   '';
        #   description = "The `sqlx` executable for database migrations.";
        # };
        format = {
          exec = "dprint fmt && dprint check";
        };
      };
    };
  });
}
