{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "mtkclient";
  version = "2.1.3-unstable-2026-02-16"; # Placeholder, will be updated by update.sh
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "mtkclient";
    rev = "c8ef31450100bce9c675448754f161850472dd04"; # Placeholder
    hash = "sha256-CJngzY/Ycu0SCBidBa+ibV2zuIobFzUx/jqsf+K6gaY="; # Placeholder
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    colorama
    fusepy
    pycryptodome
    pycryptodomex
    pyserial
    pyside6
    pyusb
    shiboken6
  ];

  pythonImportsCheck = [ "mtkclient" ];

  # Note: No need to install mtkclient udev rules, 50-android.rules is covered by
  #       systemd 258 or newer and 51-edl.rules only applies to Qualcomm (i.e. not MTK).

  meta = {
    description = "MTK reverse engineering and flash tool";
    homepage = "https://github.com/bkerler/mtkclient";
    mainProgram = "mtk";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      # loaders, preloaders and exploit payloads
      binaryFirmware
      # everything else
      fromSource
    ];
    maintainers = [ lib.maintainers.timschumi ];
  };
}
