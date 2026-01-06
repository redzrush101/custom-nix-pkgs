{ lib
, stdenv
, fetchurl
, makeWrapper
, bun
, ripgrep
}:

stdenv.mkDerivation rec {
  pname = "iflow-cli";
  version = "0.4.15";

  src = fetchurl {
    url = "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-${version}.tgz";
    hash = "sha512-Lf/sLEfu3ABHZFg07rB92VskHxcP8M1D+hjqEtfJ3UCKoJ4Cccvlo8M/K8GNUHjFsL14Nhpue6oEm52v2hUMdw==";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/iflow-cli
    cp -r . $out/libexec/iflow-cli

    rm -rf $out/libexec/iflow-cli/vendors/ripgrep
    mkdir -p $out/libexec/iflow-cli/vendors/ripgrep/x64-linux
    ln -s ${ripgrep}/bin/rg $out/libexec/iflow-cli/vendors/ripgrep/x64-linux/rg

    mkdir -p $out/bin
    makeWrapper ${bun}/bin/bun $out/bin/iflow \
      --add-flags "run $out/libexec/iflow-cli/bundle/iflow.js" \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "iFlow CLI";
    homepage = "https://github.com/iflow-ai/iflow-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "iflow";
    platforms = [ "x86_64-linux" ];
  };
}
