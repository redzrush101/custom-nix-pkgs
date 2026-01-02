{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "opencode-desktop";
  version = "1.0.223";

  src = fetchurl {
    url = "https://github.com/sst/opencode/releases/download/v${version}/opencode-desktop-linux-amd64.deb";
    hash = "sha256-v1Zm8rUO0SCzsg/OhZ5jSVRw4OoOvw50+Rdzy9FvFnE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    libsoup_3
    openssl
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg -x $src $out

    # Move usr contents to out
    mv $out/usr/* $out/
    rm -rf $out/usr

    # Fix desktop file
    substituteInPlace $out/share/applications/OpenCode.desktop \
      --replace "/usr/bin/opencode-cli" "$out/bin/opencode-cli"

    runHook postInstall
  '';

  meta = with lib; {
    description = "The open source AI coding agent";
    homepage = "https://github.com/sst/opencode";
    license = licenses.mit; # Assuming MIT, need to verify if not standard
    platforms = [ "x86_64-linux" ];
    mainProgram = "opencode-cli";
  };
}
