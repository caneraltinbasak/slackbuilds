
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p2 -R -E --backup --verbose -i ${SB_PATCHDIR}/icu.8198.revert.icu5431.patch

set +e +o pipefail
