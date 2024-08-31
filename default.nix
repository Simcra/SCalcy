{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, makeWrapper
, pkg-config
, openssl
, libxkbcommon
, fontconfig
, wayland
, xorg ? null
, ...
}:
rustPlatform.buildRustPackage rec {
  pname = "scalcy";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "simcra";
    repo = "scalcy";
    rev = "refs/tags/v${version}";
    hash = "sha256-P5La8dVDhHqTFTZwbvWLscSSCp6p9HaCTtPiDucA1Wk=";
  };

  buildInputs = lib.optionals stdenv.isLinux [
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
    makeWrapper
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/scalcy --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
  '';

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