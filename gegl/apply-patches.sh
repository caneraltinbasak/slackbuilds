
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
# Modified from upstream
patch -p0 -E --backup --verbose -z .ffmpeg -i ${SB_PATCHDIR}/gegl-0.2.0-ffmpeg.patch

set +e +o pipefail
