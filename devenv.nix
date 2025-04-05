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
      pkgs.cargo-binstall
      pkgs.cargo-run-bin
      pkgs.coreutils
      pkgs.deno
      pkgs.dprint
      pkgs.flutter
      pkgs.flyctl
      pkgs.git
      pkgs.nixfmt-rfc-style
      pkgs.rustup
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
}
