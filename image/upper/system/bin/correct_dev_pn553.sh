#!/system/bin/sh

NFC_DEVICE="/dev/pn553"

echo ""
echo "The SELinux context for  \"${NFC_DEVICE}\" is now:"
ls -lZ  ${NFC_DEVICE}
echo ""
echo "Correcting the SELinux context for the NFC device \"${NFC_DEVICE}\" ..."
chcon -v  u:object_r:nfc_device:s0  /dev/pn553
echo ""
echo "The SELinux context for  \"${NFC_DEVICE}\" is now:"
ls -lZ  ${NFC_DEVICE}

