
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/lvm2-set-default-preferred_names.patch

## Gentoo
# bug 318513
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/lvm2-2.02.64-dmeventd-libs.patch
# bug 330373
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/lvm2-2.02.89-locale-muck.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/lvm2-2.02.70-asneeded.patch 
# bug 332905
patch -p1 -E --backup -z .static --verbose -i ${SB_PATCHDIR}/lvm2-2.02.89-dynamic-static-ldflags.patch

set +e +o pipefail
