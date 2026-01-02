{ lib, stdenv, fetchurl, autoPatchelfHook, zlib, libgcc, openssl }:

stdenv.mkDerivation rec {
  pname = "opencode";
  version = "1.0.223-1";

  src = fetchurl {
    url = "https://github.com/Latitudes-Dev/shuvcode/releases/download/v${version}/shuvcode-linux-x64.tar.gz";
    hash = "sha256-x084darv3wzvnSRcFVpzXkCWT76gOzCQyUIpoCGsZB4=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  # Dependencies typically needed by bun-compiled binaries or standard linux binaries
  buildInputs = [
    zlib
    libgcc
    openssl
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 shuvcode $out/bin/opencode
    runHook postInstall
  '';

  meta = with lib; {
    description = "AI coding agent built for the terminal (Shuvcode fork)";
    homepage = "https://github.com/Latitudes-Dev/shuvcode";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "opencode";
  };
}
