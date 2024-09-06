{ lib
, stdenv
, rustPlatform
, pkg-config
, openssl
, libxkbcommon
, autoPatchelfHook
, fontconfig
, wayland
, xorg ? null
, ...
}:
let
  manifest = (lib.importTOML ./Cargo.toml).package;
in
rustPlatform.buildRustPackage rec {
  pname = manifest.name;
  version = manifest.version;
  cargoLock.lockFile = "${src}/Cargo.lock";
  src = builtins.path {
    name = "src";
    path = ./.;
  };

  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc.lib
    libxkbcommon
    fontconfig

    # Wayland
    wayland

    # Xorg/X11
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
  ];

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
    openssl
    autoPatchelfHook
  ];

  appendRunpaths = lib.makeLibraryPath buildInputs;

  meta = {
    mainProgram = pname;
    description = "A simple calculator built using Slint UI with the Rust programming language";
    homepage = "https://github.com/simcra/scalcy";
    changelog = "https://github.com/simcra/scalcy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
