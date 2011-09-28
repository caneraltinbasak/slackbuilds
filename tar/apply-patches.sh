
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
( cd ${NCSRCDIR}
  zcat ${SB_PATCHDIR}/${NAME}-1.13.bzip2.diff.gz | patch -p1 --verbose
  zcat ${SB_PATCHDIR}/tar-1.13-fortifysourcessigabrt.patch.gz | patch -p1 -E --backup --verbose
)
# Stop issuing lone zero block warnings
zcat ${SB_PATCHDIR}/${NAME}.nolonezero.diff.gz | patch -p1 --verbose
# Fix extracting sparse files to a filesystem like vfat,
# when ftruncate may fail to grow the size of a file.(rh #179507)
zcat ${SB_PATCHDIR}/${NAME}-1.15.1-vfatTruncate.patch.gz | patch -p1 -E --backup --verbose
# Add support for selinux, acl and extended attributes
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/tar-1.24-xattrs.patch
# --wildcards-match-slash" for compatibility reasons
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/tar-1.17-wildcards.patch
# ignore errors from setting utime() for source file on read-only filesystem
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/tar-1.22-atime-rofs.patch
#oldarchive option was not working(#594044)
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/tar-1.23-oldarchive.patch
#partially revert upstream commit 4bde4f3 (#717684)
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/tar-1.24-openat-partial-revert.patch

# Adds txz support
zcat ${SB_PATCHDIR}/${NAME}-1.23-support_txz.diff.gz | patch -p1 -E --backup --verbose

set +e +o pipefail
