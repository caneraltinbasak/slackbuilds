#!/bin/sh

set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# Set to test (some patches require others, so, is not 100%)
DRYRUN=${DRYRUN:-NO}

if [ "${DRYRUN}" = "YES" ] ; then
  DRYRUN_OPT="--dry-run"
fi

if [ "${VERBOSE}" = "YES" ] ; then
  VERBOSE_OPT="--verbose"
fi

if [ "${SVERBOSE}" = "YES" ] ; then
  set -o xtrace
fi

PATCHCOM="patch ${DRYRUN_OPT} -p1 -F1 -s ${VERBOSE_OPT}"

ApplyPatch() {
  local patch=$1
  shift
  if [ ! -f ${SB_PATCHDIR}/${patch} ]; then
    exit 1
  fi
  case "${patch}" in
  *.bz2) bzcat "${SB_PATCHDIR}/${patch}" | ${PATCHCOM} ${1+"$@"} ;;
  *.gz) zcat "${SB_PATCHDIR}/${patch}" | ${PATCHCOM} ${1+"$@"} ;;
  *) ${PATCHCOM} ${1+"$@"} -i "${SB_PATCHDIR}/${patch}" ;;
  esac
}

ApplyOptionalPatch() {
  local patch=$1
  shift
  if [ ! -f ${SB_PATCHDIR}/${patch} ]; then
    exit 1
  fi
  case "${patch}" in
  *.bz2) local C=$(bzcat ${SB_PATCHDIR}/${patch} | wc -l | awk '{print $1}') ;;
  *.gz) local C=$(zcat ${SB_PATCHDIR}/${patch} | wc -l | awk '{print $1}') ;;
  *) local C=$(wc -l ${SB_PATCHDIR}/${patch} | awk '{print $1}') ;;
  esac
  if [ "${C}" -gt 9 ]; then
    ApplyPatch ${patch} ${1+"$@"}
  fi
}

# Qt4 xconfig
ApplyPatch 2900_xconfig-with-qt4.patch
ApplyPatch 2905_proper-qt4-detection.patch

ApplyOptionalPatch git-linus.diff

# This patch adds a "make nonint_oldconfig" which is non-interactive and
# also gives a list of missing options at the end. Useful for automated
# builds (as used in the buildsystem).
#ApplyPatch linux-2.6-build-nonintconfig.patch

ApplyPatch linux-2.6-makefile-after_link.patch

#
# misc small stuff to make things compile
#
ApplyOptionalPatch linux-2.6-compile-fixes.patch.gz

# revert patches from upstream that conflict or that we get via other means
ApplyOptionalPatch linux-2.6-upstream-reverts.patch -R

ApplyOptionalPatch linux-2.6-hotfixes.patch

# Roland's utrace ptrace replacement.
ApplyPatch linux-2.6-tracehook.patch
ApplyPatch linux-2.6-utrace.patch
ApplyPatch linux-2.6-utrace-ptrace.patch

# vm patches

# Architecture patches
# x86(-64)
# Add K10 and native cpu optimization support
ApplyPatch linux-2.6-add-cpu-optimizations.patch

#
# Intel IOMMU
#

#
# Exec shield
#
ApplyPatch linux-2.6-i386-nx-emulation.patch
ApplyPatch linux-2.6-32bit-mmap-exec-randomization.patch

#
# bugfixes to drivers and filesystems
#
#rhbz#662344
ApplyPatch fs-call-security_d_instantiate-in-d_obtain_alias.patch

# ext4

# xfs

# btrfs
# rhbz#656465
ApplyPatch btrfs-fix-error-handling-in-btrfs_get_sb.patch
ApplyPatch btrfs-fix-race-between-btrfs_get_sb-and-umount.patch
ApplyPatch btrfs-setup-blank-root-and-fs_info-for-mount-time.patch

# cifs

# NFSv4

# USB

# WMI

# ACPI
ApplyPatch linux-2.6-defaults-acpi-video.patch.gz
ApplyPatch linux-2.6-acpi-video-dos.patch
ApplyPatch acpi-ec-add-delay-before-write.patch
ApplyPatch linux-2.6-acpi-debug-infinite-loop.patch
ApplyPatch acpi-update-battery-information-on-notification-0x81.patch

# Various low-impact patches to aid debugging.
ApplyPatch linux-2.6-debug-sizeof-structs.patch
ApplyPatch linux-2.6-debug-nmi-timeout.patch
ApplyPatch linux-2.6-debug-taint-vm.patch
## try to find out what is breaking acpi-cpufreq
#ApplyPatch linux-2.6-debug-vm-would-have-oomkilled.patch
ApplyPatch linux-2.6-debug-always-inline-kzalloc.patch.gz

ApplyPatch debug-tty-print-dev-name.patch

#
# PCI
#
# disable message signaled interrupts
ApplyPatch linux-2.6-defaults-pci_no_msi.patch
ApplyPatch linux-2.6-defaults-pci_use_crs.patch
# enable ASPM by default on hardware we expect to work
ApplyPatch linux-2.6-defaults-aspm.patch.gz
ApplyPatch pci-disable-aspm-if-bios-asks-us-to.patch

# helps debug resource conflicts [c1f3f281]
ApplyPatch pnp-log-pnp-resources-as-we-do-for-pci.patch

ApplyPatch ima-allow-it-to-be-completely-disabled-and-default-off.patch

#
# SCSI Bits.
#

# ALSA
ApplyPatch hda_intel-prealloc-4mb-dmabuffer.patch

# block/bio
#

# Networking

# Misc fixes
# The input layer spews crap no-one cares about.
ApplyPatch linux-2.6-input-kill-stupid-messages.patch

# stop floppy.ko from autoloading during udev...
ApplyPatch die-floppy-die.patch

ApplyPatch linux-2.6.30-no-pcspkr-modalias.patch.gz

#ApplyPatch thinkpad-acpi-fix-backlight.patch

# Allow to use 480600 baud on 16C950 UARTs
ApplyPatch linux-2.6-serial-460800.patch

# Silence some useless messages that still get printed with 'quiet'
ApplyPatch linux-2.6-silence-noise.patch

# Make fbcon not show the penguins with 'quiet'
ApplyPatch linux-2.6-silence-fbcon-logo.patch.gz

# Changes to upstream defaults.


# libata

#
# VM related fixes.
#

# /dev/crash driver.
ApplyPatch linux-2.6-crash-driver.patch

# crypto/

# Assorted Virt Fixes
ApplyPatch fix_xen_guest_on_old_EC2.patch

# Nouveau DRM
ApplyOptionalPatch drm-nouveau-updates.patch

# Intel DRM
#ApplyOptionalPatch drm-intel-next.patch
ApplyPatch drm-intel-big-hammer.patch
ApplyPatch drm-intel-make-lvds-work.patch
ApplyPatch linux-2.6-intel-iommu-igfx.patch

# linux1394 git patches
# apply if non-empty
#ApplyOptionalPatch linux-2.6-firewire-git-update.patch
#ApplyOptionalPatch linux-2.6-firewire-git-pending.patch.gz

# silence the ACPI blacklist code
ApplyPatch linux-2.6-silence-acpi-blacklist.patch

# V4L/DVB updates/fixes/experimental drivers
ApplyOptionalPatch linux-2.6-v4l-dvb-fixes.patch
ApplyOptionalPatch linux-2.6-v4l-dvb-update.patch
ApplyOptionalPatch linux-2.6-v4l-dvb-experimental.patch
#ApplyPatch linux-2.6-v4l-dvb-uvcvideo-update.patch

#ApplyPatch linux-2.6-v4l-dvb-add-lgdt3304-support.patch

# http://www.lirc.org/
#ApplyPatch lirc-staging-2.6.36.patch
# enable IR receiver on Hauppauge HD PVR (v4l-dvb merge pending)
ApplyPatch hdpvr-ir-enable.patch

# Patches headed upstream
ApplyPatch disable-i8042-check-on-apple-mac.patch

ApplyPatch neuter_intel_microcode_load.patch

# try to fix stalls during boot (#530393)
ApplyPatch tpm-fix-stall-on-boot.patch

# Runtime PM
ApplyPatch linux-2.6-bluetooth-autosuspend.patch
ApplyPatch linux-2.6-uvc-autosuspend.patch
ApplyPatch linux-2.6-qcserial-autosuspend.patch
ApplyPatch linux-2.6-usb-pci-autosuspend.patch
ApplyPatch linux-2.6-enable-more-pci-autosuspend.patch
ApplyPatch runtime_pm_fixups.patch

# PCI patches to fix problems with _CRS
# ( from linux-pci list )
ApplyPatch pci-crs-fixes.patch
ApplyPatch x86-never-alloc-pci-from-the-last-1M-below-4G.patch

# rhbz#605888
ApplyPatch dmar-disable-when-ricoh-multifunction.patch

ApplyPatch xhci_hcd-suspend-resume.patch

ApplyPatch fix-i8k-inline-asm.patch

# rhbz#651264 (CVE-2010-3880)
ApplyPatch inet_diag-make-sure-we-run-the-same-bytecode-we-audited.patch
ApplyPatch netlink-make-nlmsg_find_attr-take-a-const-ptr.patch

# rhbz#656264
ApplyPatch posix-cpu-timers-workaround-to-suppress-problems-with-mt-exec.patch

# CVE-2010-4077, CVE-2010-4075 (rhbz#648660, #648663)
ApplyPatch tty-make-tiocgicount-a-handler.patch
ApplyPatch tty-icount-changeover-for-other-main-devices.patch

ApplyPatch tpm-autodetect-itpm-devices.patch

# backport some fixes for kswapd from mmotm, rhbz#649694
ApplyPatch mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
ApplyPatch mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch

# rhbz#650934
ApplyPatch sched-cure-more-NO_HZ-load-average-woes.patch

# rhbz#657864 [229bd792]
ApplyPatch orinoco-initialise-priv_hw-before-assigning-the-interrupt.patch

# rhbz#637619
ApplyPatch net-AF_PACKET-vmalloc.patch

unset DRYRUN DRYRUN_OPT VERBOSE VERBOSE_OPT SVERBOSE

set +e +o pipefail +o xtrace
