#
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2024 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/google/husky
DEVICE_COMMON_PATH := device/google/zuma

include $(DEVICE_COMMON_PATH)/BoardConfig-common.mk
include vendor/google/husky/BoardConfigVendor.mk

TARGET_BOARD_INFO_FILE := $(DEVICE_PATH)/board-info.txt
TARGET_BOOTLOADER_BOARD_NAME := husky

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# 12.1 manifest requirements
TARGET_SUPPORTS_64_BIT_APPS := true
TARGET_IS_64_BIT := true
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_MISSING_REQUIRED_MODULES := true

# A/B
AB_OTA_UPDATER := true

# Architecture
TARGET_SOC := zuma

TARGET_SOC_NAME := google

USES_DEVICE_GOOGLE_ZUMA := true
USES_DEVICE_GOOGLE_HUSKY := true
USES_DEVICE_GOOGLE_SHUSKY := true

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a55
TARGET_CPU_VARIANT_RUNTIME := cortex-a55

# Enable 64-bit for non-zygote.
ZYGOTE_FORCE_64 := true

# Force any prefer32 targets to be compiled as 64 bit.
IGNORE_PREFER32_ON_DEVICE := true

ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := husky
TARGET_NO_BOOTLOADER := true

# Display
TARGET_SCREEN_DENSITY := 480
TARGET_USES_VULKAN := true
BOARD_EGL_CFG := $(DEVICE_COMMON_PATH)/conf/egl.cfg

# EMULATOR common modules
BOARD_EMULATOR_COMMON_MODULES := liblight

# Kernel
TARGET_KERNEL_DTBO_PREFIX := dts/
TARGET_KERNEL_DTBO := google-devices/shusky/dtbo.img
TARGET_KERNEL_DTB := \
    google-devices/husky/google-base/zuma-a0-ipop.dtb \
    google-devices/husky/google-base/zuma-b0-ipop.dtb

# Kernel modules
BOARD_VENDOR_KERNEL_MODULES_LOAD_RAW := $(strip $(shell cat $(DEVICE_PATH)/recovery/root/vendor_dlkm.modules.load))
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(foreach m,$(BOARD_VENDOR_KERNEL_MODULES_LOAD_RAW),$(notdir $(m)))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD_RAW := $(strip $(shell cat $(DEVICE_PATH)/recovery/root/vendor_kernel_boot.modules.load))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(foreach m,$(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD_RAW),$(notdir $(m)))
BOOT_KERNEL_MODULES := $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD)
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE := $(DEVICE_PATH)/recovery/root/vendor_dlkm.modules.blocklist
TARGET_KERNEL_EXT_MODULE_ROOT := kernel/google/zuma/google-modules

TARGET_KERNEL_EXT_MODULES := \
    aoc/usb \
    bms \
    display/samsung \
    edgetpu/rio/drivers/edgetpu \
    gpu/mali_kbase \
    gpu/mali_pixel \
    gxp/zuma \
    lwis \
    power/reset \
    touch/common \
    touch/fts/fst2 \
    touch/fts/ftm5 \
    touch/goodix \
    uwb/qorvo/qm35 \
    uwb/qorvo/qm35s \
    video/gchips \
    ../google-devices/shusky/display

# Partitions
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
BOARD_SUPER_PARTITION_SIZE := 9126805504 # TODO: Fix hardcoded value
BOARD_SUPER_PARTITION_GROUPS := google_dynamic_partitions
BOARD_GOOGLE_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext product vendor vendor_dlkm
BOARD_GOOGLE_DYNAMIC_PARTITIONS_SIZE := 9122611200 # TODO: Fix hardcoded value

VENDOR_CMDLINE := "dyndbg=\"func alloc_contig_dump_pages +p\" \
                earlycon=exynos4210,0x10A00000 console=ttySAC0,115200 androidboot.console=ttySAC0 printk.devkmsg=on \
                swiotlb=noforce \
		cma_sysfs.experimental=Y \
		cgroup_disable=memory \
		rcupdate.rcu_expedited=1 \
		rcu_nocbs=all \
		stack_depot_disable=off \
		page_pinner=on \
		swiotlb=1024 \
		disable_dma32=on \
                at24.write_timeout=100 \
		log_buf_len=1024K \
		bootconfig"

BOARD_BOOTCONFIG += androidboot.load_modules_parallel=true
BOARD_KERNEL_CMDLINE += exynos_drm.load_sequential=1

# Kernel
BOARD_KERNEL_BASE        := 0x1000000
BOARD_KERNEL_PAGESIZE    := 2048
BOARD_KERNEL_OFFSET      := 0x00008000
BOARD_RAMDISK_OFFSET     := 0x01000000
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_DTB_OFFSET         := 0x01f00000

# vendor_boot as recovery
BOARD_BOOT_HEADER_VERSION := 4
BOARD_USES_RECOVERY_AS_BOOT := false
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := false
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_IMAGE_NAME := Image.lz4
TARGET_KERNEL_CONFIG := gki_defconfig
TARGET_KERNEL_SOURCE := kernel/google/zuma
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.lz4
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/dtbs
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbs/dtbo.img
BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION) 
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --vendor_cmdline $(VENDOR_CMDLINE)

# Platform
TARGET_BOARD_PLATFORM := zuma

# Colour fix stuff
TARGET_RECOVERY_PIXEL_FORMAT := ABGR_8888
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 165
TARGET_RECOVERY_UI_LIB := \
	librecovery_ui_pixel \
# HWComposer
BOARD_HWC_VERSION := hwc3
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := false
BOARD_HDMI_INCAPABLE := true
TARGET_USES_HWC2 := true
HWC_SUPPORT_RENDER_INTENT := true
HWC_SUPPORT_COLOR_TRANSFORM := true
#BOARD_USES_DISPLAYPORT := true
# if AFBC is enabled, must set ro.vendor.ddk.set.afbc=1
BOARD_USES_EXYNOS_AFBC_FEATURE := true
#BOARD_USES_HDRUI_GLES_CONVERSION := true

BOARD_LIBACRYL_DEFAULT_COMPOSITOR := fimg2d_zuma
BOARD_LIBACRYL_G2D_HDR_PLUGIN := libacryl_hdr_plugin

# HWCServices
BOARD_USES_HWC_SERVICES := true

# Recovery
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_RECOVERY_WIPE := $(DEVICE_PATH)/recovery.wipe

# Ramdisk compression
BOARD_RAMDISK_USE_LZ4 := true

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# Enable chained vbmeta for boot images
BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA2048
BOARD_AVB_BOOT_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 2

# Enable chained vbmeta for init_boot images
BOARD_AVB_INIT_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_INIT_BOOT_ALGORITHM := SHA256_RSA2048
BOARD_AVB_INIT_BOOT_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_INIT_BOOT_ROLLBACK_INDEX_LOCATION := 4

# Hack: prevent anti rollback
PLATFORM_VERSION := 99.87.36
PLATFORM_SECURITY_PATCH := 2127-12-31
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# sepolicy
SELINUX_IGNORE_NEVERALLOWS := true

# Load Touch modules files
TW_LOAD_VENDOR_MODULES := "heatmap.ko touch_offload.ko ftm5.ko sec_touch.ko goodix_brl_touch.ko goog_touch_interface.ko"

# TWRP specific build flags
TWRP_EVENT_LOGGING := true
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
TW_THEME := portrait_hdpi
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TW_EXTRA_LANGUAGES := true
TW_NO_SCREEN_BLANK := true
TW_NO_SCREEN_TIMEOUT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_MAX_BRIGHTNESS := 1600
TW_INCLUDE_FASTBOOTD := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.0/lun.%d/file
TW_USE_TOOLBOX := true
TW_INCLUDE_REPACKTOOLS := true
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_RESETPROP_SOURCE := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_LIBRESETPROP_SOURCE := true
TW_EXCLUDE_APEX := true
#TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_USE_CRYPTO := true
TW_Y_OFFSET := 80
TW_H_OFFSET := -80
TW_OVERRIDE_SYSTEM_PROPS := \ 
"ro.bootimage.build.date.utc=ro.build.date.utc;ro.build.date.utc;ro.odm.build.date.utc=ro.build.date.utc;ro.product.build.date.utc=ro.build.date.utc;ro.system.build.date.utc=ro.build.date.utc;ro.system_ext.build.date.utc=ro.build.date.utc;ro.vendor.build.date.utc=ro.build.date.utc;ro.build.product;ro.build.fingerprint=ro.system.build.fingerprint;ro.build.version.incremental;ro.product.name=ro.product.system.name"
