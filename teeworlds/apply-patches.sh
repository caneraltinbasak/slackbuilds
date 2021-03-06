
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup -z .extlibs --verbose -i ${SB_PATCHDIR}/${NAME}-0.6.1-extlibs.patch

set +e +o pipefail
