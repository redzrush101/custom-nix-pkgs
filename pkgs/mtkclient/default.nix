{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "mtkclient";
  version = "2.1.3-unstable-2026-02-06"; # Placeholder, will be updated by update.sh
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "mtkclient";
    rev = "32d7a0e1dddf5904fd5adde5e4fd7402e4ae01c4"; # Placeholder
    hash = "sha256-JsPkUORt98q/mMlNt9TeCgTCjainIFMA5pezdE2gTko="; # Placeholder
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
