{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libxkbcommon,
  autoPatchelfHook,
  fontconfig,
  wayland,
  xorg ? null,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "scalcy";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "simcra";
    repo = "scalcy";
    rev = "refs/tags/v${version}";
    hash = "sha256-2j3UqH15kolzIeDxAWQbGael77p16ATJBiVH3v9H68o=";
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
    wayland
    pkg-config
    openssl
    autoPatchelfHook
  ];

  appendRunpaths = [
    (lib.makeLibraryPath [
      fontconfig
      wayland
      libxkbcommon
    ])
  ];

  cargoLock = {
    lockFile = src + /Cargo.lock;
  };

  meta = {
    mainProgram = pname;
    description = "A simple calculator built using Slint UI with the Rust programming language";
    homepage = "https://github.com/simcra/scalcy";
    changelog = "https://github.com/simcra/scalcy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
