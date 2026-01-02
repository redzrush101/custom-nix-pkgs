{ lib, stdenv, makeDesktopItem, copyDesktopItems, opencode, iconSrc ? null }:

stdenv.mkDerivation {
  pname = "shuvcode-desktop";
  version = opencode.version;

  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "shuvcode";
      desktopName = "ShuvCode";
      exec = "opencode %F";
      terminal = true;
      icon = if iconSrc != null then "${iconSrc}" else "opencode";
      categories = [ "Development" "TextEditor" ];
      comment = "AI coding agent built for the terminal";
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ln -s ${opencode}/bin/opencode $out/bin/opencode
    runHook postInstall
  '';

  meta = with lib; {
    description = "Desktop entry for ShuvCode (opencode)";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
