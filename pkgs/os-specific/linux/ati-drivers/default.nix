{ stdenv, fetchurl, kernel ? null, xlibs, which, imake
, mesa # for fgl_glxgears
, libXxf86vm, xf86vidmodeproto # for fglrx_gamma
, xorg, makeWrapper, glibc, patchelf
, unzip
, qt4 # for amdcccle
, # Whether to build the libraries only (i.e. not the kernel module or
  # driver utils). Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

assert (!libsOnly) -> kernel != null;

# If you want to use a different Xorg version probably
# DIR_DEPENDING_ON_XORG_VERSION in builder.sh has to be adopted (?)
# make sure libglx.so of ati is used. xorg.xorgserver does provide it as well
# which is a problem because it doesn't contain the xorgserver patch supporting
# the XORG_DRI_DRIVER_PATH env var.
# See http://thread.gmane.org/gmane.linux.distributions.nixos/4145 for a
# workaround (TODO)

# The gentoo ebuild contains much more magic and is usually a great resource to
# find patches :)

# http://wiki.cchtml.com/index.php/Main_Page

# There is one issue left:
# /usr/lib/dri/fglrx_dri.so must point to /run/opengl-driver/lib/fglrx_dri.so

with stdenv.lib;

stdenv.mkDerivation {
  name = "ati-drivers-14.12" + (optionalString (!libsOnly) "-${kernel.version}");

  builder = ./builder.sh;

  inherit libXxf86vm xf86vidmodeproto;
  gcc = stdenv.cc.gcc;

  src = fetchurl {
    url = http://www2.ati.com/drivers/linux/amd-catalyst-omega-14.12-linux-run-installers.zip;
    sha256 = "0jd2scrdlyapynxfjdrarnwcdzxjqrk5fg5i10g3bm0ay8v9hrk8";
    curlOpts = "--referer http://support.amd.com/en-us/download/desktop?os=Linux%20x86_64";
  };

  patchPhase = "patch -p1 < ${./fglrx_3.17rc6-no_hotplug.patch}";
  patchPhaseSamples = "patch -p2 < ${./patch-samples.patch}";

  buildInputs =
    [ xlibs.libXext xlibs.libX11 xlibs.libXinerama
      xlibs.libXrandr which imake makeWrapper
      patchelf
      unzip
      mesa
      qt4
    ];

  inherit libsOnly;

  kernel = if libsOnly then null else kernel.dev;

  inherit glibc /* glibc only used for setting interpreter */;

  LD_LIBRARY_PATH = stdenv.lib.concatStringsSep ":"
    [ "${xorg.libXrandr}/lib"
      "${xorg.libXrender}/lib"
      "${xorg.libXext}/lib"
      "${xorg.libX11}/lib"
      "${xorg.libXinerama}/lib"
    ];

  # without this some applications like blender don't start, but they start
  # with nvidia. This causes them to be symlinked to $out/lib so that they
  # appear in /run/opengl-driver/lib which get's added to LD_LIBRARY_PATH
  extraDRIlibs = [ xorg.libXext ];

  inherit mesa qt4; # only required to build examples and amdcccle

  meta = with stdenv.lib; {
    description = "ATI drivers";
    homepage = http://support.amd.com/us/gpudownload/Pages/index.aspx;
    license = licenses.unfree;
    maintainers = with maintainers; [ marcweber offline jgeerds ];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
