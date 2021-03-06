
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-0.6.9-desktop-files.patch
patch -p1 -E --backup -z .sys-quazip --verbose -i ${SB_PATCHDIR}/${NAME}-0.8.0-system-quazip.patch

set +e +o pipefail
