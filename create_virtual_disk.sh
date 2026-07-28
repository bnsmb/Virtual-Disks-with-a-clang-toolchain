#!/bin/bash

IMAGE_SIZE="2g"
IMAGE_FILE="/tmp/perl544_and_clang_virtual_image"
MOUNT_POINT="/tmp/mount_point"

BS_COUNT="262144"
BS_SIZE="8192"

THISRC=1

if [ -r "${IMAGE_FILE}" ] ; then
  BACKUP_FILE="${IMAGE_FILE}.$$.bkp"
  echo "Renaming the existing image file \"${IMAGE_FILE}\" to \"${BACKUP_FILE}\" ...."
  mv "${IMAGE_FILE}"  "${BACKUP_FILE}"
fi

echo "Creating the image file \"${IMAGE_FILE}\" (Size: "${IMAGE_SIZE}") ..."

dd if=/dev/zero of=${IMAGE_FILE} bs=${BS_COUNT} count=${BS_SIZE} && \
  mkfs.ext3 "${IMAGE_FILE}" && \
  mkdir -p "${MOUNT_POINT}" && \
  sudo mount "${IMAGE_FILE}" "${MOUNT_POINT}" && \
  sudo cp -a -r image/*  "${MOUNT_POINT}" && \
  echo "\"${IMAGE_FILE}\" successfully created" && \
  THISRC=0

  if [ ${THISRC} = 0 ] ; then

    sudo mkdir -p "${MOUNT_POINT}/merged"
    sudo mkdir -p "${MOUNT_POINT}/upper"
    sudo mkdir -p "${MOUNT_POINT}/work"

    sudo chmod 777 "${MOUNT_POINT}/merged"
    sudo chmod 777 "${MOUNT_POINT}/upper"
    sudo chmod 777 "${MOUNT_POINT}/work"

    echo "Setting up work directories with special permissions..."

    sudo mkdir -p  ${MOUNT_POINT}/work/system/work
    sudo chmod 777 ${MOUNT_POINT}/work
    sudo chmod 755 ${MOUNT_POINT}/work/system
    sudo chmod 0   ${MOUNT_POINT}/work/system/work 

    echo "Setting file ownership to root..."
    sudo chown -R root:root ${MOUNT_POINT}/

    # Create script to display image version
    echo 'echo "# $( date +%s ) # Virtual disk created at $( date )"' | sudo tee ${MOUNT_POINT}/upper/system/bin/print_image_version >/dev/null
    sudo chmod 755 ${MOUNT_POINT}/upper/system/bin/print_image_version

    sudo umount "${MOUNT_POINT}" 
    rmdir "${MOUNT_POINT}"
  fi

  echo "Script ends with RC=${THISRC}"

exit ${THISRC}

