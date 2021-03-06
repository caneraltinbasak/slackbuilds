
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup -z .ssl-verify --verbose -i ${SB_PATCHDIR}/links-2.3pre2-ssl-verify.patch

set +e +o pipefail
