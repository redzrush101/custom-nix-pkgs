{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  glib,
  cairo,
  pango,
  gdk-pixbuf,
  atk,
  usbmuxd,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "iloader";
  version = "2.0.3";

  src = fetchurl {
    url = "https://github.com/nab138/iloader/releases/download/v${version}/iloader-linux-amd64.deb";
    sha256 = "0b3ba6bb6638926a0155979d393b8990865f88c8efcd82531a9d4fb27ae3ad8b";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    libsoup_3
    glib
    cairo
    pango
    gdk-pixbuf
    atk
    openssl
  ];

  runtimeDependencies = [
    usbmuxd
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp usr/bin/iloader $out/bin/

    mkdir -p $out/share
    cp -r usr/share/applications $out/share/
    cp -r usr/share/icons $out/share/

    runHook postInstall
  '';

  meta = with lib; {
    description = "User-friendly sideloader for iOS";
    homepage = "https://github.com/nab138/iloader";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "iloader";
  };
}
