
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

zcat ${SB_PATCHDIR}/libgcrypt-1.4.4-multilib.patch.gz | patch -p0 -E --backup --verbose
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/libgcrypt-1.4.5-ImplicitDSOLinking.patch


set +e +o pipefail
