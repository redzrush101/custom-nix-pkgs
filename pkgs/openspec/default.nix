{ lib
, buildNpmPackage
, fetchFromGitHub
, pkgs
}:

buildNpmPackage rec {
  pname = "openspec";
  version = "0.17.2-unstable-2025-01-04";

  src = fetchFromGitHub {
    owner = "Fission-AI";
    repo = "OpenSpec";
    rev = "c47cdaafe28d892cf6af428e00e512f97898e096";
    hash = "sha256-NKbzDPDfsCS3yFubqxaoC3T102/2KhB09HUoG7qBfFA=";
  };

  npmDepsHash = "sha256-czytzCEPSnnT1nLiuKwom3xJEqByApuedg2+h6+Hs4g=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    # Remove all scripts that use pnpm
    ${lib.getExe' pkgs.jq "jq"} 'del(.scripts.postinstall) | del(.scripts.prepare) | .scripts.build = "node build.js"' package.json > package.json.tmp && mv package.json.tmp package.json
  '';

  meta = with lib; {
    description = "AI-native system for spec-driven development";
    homepage = "https://github.com/Fission-AI/OpenSpec";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "openspec";
    platforms = platforms.linux;
  };
}
