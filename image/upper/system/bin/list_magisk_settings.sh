#!/system/bin/sh

cd /data/adb/magisk
grep ' / ' /proc/mounts | grep -qv 'rootfs' && SYSTEM_ROOT=true
. ./util_functions.sh
get_flags
echo -------------------------
echo "SYSTEM_ROOT:       $SYSTEM_ROOT"
echo "KEEPVERITY:        $KEEPVERITY"
echo "KEEPFORCEENCRYPT:  $KEEPFORCEENCRYPT"
echo "RECOVERYMODE:      $RECOVERYMODE"
echo "PATCHVBMETAFLAG:   $PATCHVBMETAFLAG"
echo "ISENCRYPTED:       $ISENCRYPTED"
echo "VBMETAEXIST:       $VBMETAEXIST"


