{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  pkg-config,
  kdePackages,
  qt6,
  shared-mime-info,
  bison,
  flex,

  gsl,

  fftw,
  hdf5,
  netcdf,
  cfitsio,
  libcerf,
  zlib,
  lz4,
  readstat,
  matio,
  discount,
  eigen,
  liborcus,
  libixion,
  vector-blf,
  qt6Packages,
  zstd,
  boost,
  liborigin,
  glibcLocales,
  dbc-parser-cpp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "labplot";
  version = "2.12.1";

  src = fetchurl {
    url = "mirror://kde/stable/labplot/labplot-${finalAttrs.version}.tar.xz";
    hash = "sha256-4oFVv930DltvfEeRMTVW0eSBOARPIW8hDVFbn21sEGo=";
  };

  patches = [
    # backport build fix
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://invent.kde.org/education/labplot/-/commit/c2db2ec28aa8958f7041ae5cd03ddae9f44e5aa3.diff";
      hash = "sha256-0biKZXWMs5y1U9phAivEAbd2N4C/CiOKvk/QRAaPimo=";
    })

    # support liborcus-0.21
    (fetchpatch {
      url = "https://invent.kde.org/education/labplot/-/commit/ee17e7659a97b36b58cab28b2b56cede7cd153c6.patch";
      sha256 = "sha256-NC5CjO4X27NGlt17CwcPNsLx4ClbpE1zacH/XGaWwTs=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    shared-mime-info
    bison
    flex
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase

    kdePackages.karchive
    kdePackages.kcompletion
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.kcrash
    kdePackages.kdoctools
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kio
    kdePackages.knewstuff
    kdePackages.kparts
    kdePackages.ktextwidgets
    kdePackages.kxmlgui

    kdePackages.kuserfeedback
    kdePackages.purpose

    kdePackages.syntax-highlighting
    gsl

    kdePackages.poppler
    fftw
    hdf5
    netcdf
    cfitsio
    libcerf
    kdePackages.cantor
    zlib
    lz4
    readstat
    matio
    qt6.qtserialport
    discount

    qt6.qtmqtt
    qt6Packages.qxlsx

    eigen
    liborcus
    libixion
    vector-blf
    dbc-parser-cpp
    zstd
    boost
    liborigin
  ];

  cmakeFlags = [
    (lib.cmakeBool "QT_FIND_PRIVATE_MODULES" true)
    (lib.cmakeBool "ENABLE_REPRODUCIBLE" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  nativeCheckInputs = [ glibcLocales ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_QPA_PLATFORM=offscreen
    export TZ=UTC
    export LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive
  '';

  doCheck = true;

  meta = {
    description = "Free, open source and cross-platform data visualization and analysis software accessible to everyone";
    homepage = "https://labplot.kde.org";
    license = with lib.licenses; [
      asl20
      bsd3
      cc-by-30
      cc0
      gpl2Only
      gpl2Plus
      gpl3Only
      gpl3Plus
      lgpl3Plus
      mit
    ];
    maintainers = with lib.maintainers; [
      AhmedAmr
    ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "labplot";
    platforms = lib.platforms.all;
  };
})
