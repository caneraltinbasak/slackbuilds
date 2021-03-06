
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p2 -E --backup --verbose -i ${SB_PATCHDIR}/js-1.8.5-64bit-big-endian.patch
patch -p2 -E --backup --verbose -i ${SB_PATCHDIR}/js-1.8.5-secondary-jit.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/js185-destdir.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/js-1.8.5-537701.patch

set +e +o pipefail
