
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.20.51.0.2-libtool-lib64.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.20.51.0.2-version.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.20.51.0.2-set-long-long.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.20.51.0.10-copy-osabi.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.20.51.0.10-sec-merge-emit.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.22.52.0.1-relro-on-by-default.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.22.52.0.1-export-demangle.h.patch
# Disable checks that config.h has been included before system headers.  BZ #845084
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.22.52.0.4-no-config-h-check.patch
# Fix the creation of the index table in 64-bit thin archives.
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.23.52.0.1-64-bit-thin-archives.patch
# Fix errors reported by version 5.0 of texinfo
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.23.52.0.1-as-doc-texinfo-fixes.patch
# Revert HJ's patch for  PR15149.  This stops the reporting of weak DT_NEEDED symbols.
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.23.52.0.1-revert-pr15149.patch
# Fix addr2line to use the dynamic symbol table if it could not find any ordinary symbols.
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.23.52.0.1-addr2line-dynsymtab.patch
# Check regular references without non-GOT references when building shared libraries.
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.23.52.0.1-check-regular-ifunc-refs.patch

set +e +o pipefail
