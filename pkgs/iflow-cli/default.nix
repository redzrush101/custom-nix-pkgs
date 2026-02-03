{ lib
, stdenv
, fetchurl
, makeWrapper
, bun
, ripgrep
}:

stdenv.mkDerivation rec {
  pname = "iflow-cli";
  version = "0.5.5";

  src = fetchurl {
    url = "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-${version}.tgz";
    hash = "sha512-x/tWNdWUKQebzCVVcO5GDcYoNj4JKx8Clo+Rzi4UqHMkOAgX0bGEV4jkzZ/SEzI/f/hRBh5/nhyNUIlOd2YMUQ==";
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
