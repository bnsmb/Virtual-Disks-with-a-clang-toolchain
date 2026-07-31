#!/bin/bash

IMAGE_SIZE="${IMAGE_SIZE:=2g}"
IMAGE_FILE="${IMAGE_FILE:=/tmp/perl544_and_clang_virtual_image}"
MOUNT_POINT="${MOUNT_POINT:=/tmp/mount_point.$$}"

#BS_COUNT="262144"

BS_SIZE="8192"

THISRC=1

while [ $# -ne 0 ] ; do
	CUR_PARAMETER="$1"
	shift

	case ${CUR_PARAMETER} in

		-h | --help | help )
			echo "Usage: $0 [IMAGE_SIZE=n] [IMAGE_FILE=file] [MOUNT_POINT=mount_point]"
			exit 1
			;;	

     	 	*=* )
       		 	CUR_VAR="${CUR_PARAMETER%%=*}"
       		 	CUR_VAL="${CUR_PARAMETER#*=}"
       		 	eval ${CUR_VAR}=\"${CUR_VAL}\"
       		 	if [ $? -ne 0 ] ; then

       		   		echo "ERROR: Error executing \"${CUR_PARAMETER}\" "
		  		exit 5
			fi
			;;

		* ) 
			echo "ERROR: Unknown parameter: \"${CUR_PARAMETER}\" "
			exit 10
			;;

	esac
done

IMAGE_SIZE="$( echo "${IMAGE_SIZE}" | tr "[A-Z]" "[a-z]" )"

case ${IMAGE_SIZE} in
	*g ) 
		(( IMAGE_SIZE_IN_BYTES=${IMAGE_SIZE%g} * 1024 * 1024 * 1024 ))
		;;
	*m )	((  IMAGE_SIZE_IN_BYTES=${IMAGE_SIZE%m} * 1024 * 1024 ))
		;;
	*k )	((  IMAGE_SIZE_IN_BYTES=${IMAGE_SIZE%k} * 1024 ))
		;;
	* )	IMAGE_SIZE_IN_BYTES=${IMAGE_SIZE}
		;;
esac

(( BS_COUNT = IMAGE_SIZE_IN_BYTES / BS_SIZE ))

echo 
echo "Creating the image file \"${IMAGE_FILE}\" with the size: ${IMAGE_SIZE} (= ${IMAGE_SIZE_IN_BYTES}) using the temporary mount point \"${MOUNT_POINT}\"  ..."
echo

if [ "${PREFIX}"x != ""x ] ; then
	echo "The prefix for the commands to execute is \"${PREFIX}\" "
	echo
fi

echo "*** Press return to continue or CTRL-C to abort ..."
read USER_INPUT


if [ ! -d image/upper ] ; then
	echo "ERROR: This script must be run in the directory with the files for the virtual disk."
	exit 15
fi

if [ -r "${IMAGE_FILE}" ] ; then
  BACKUP_FILE="${IMAGE_FILE}.$$.bkp"
  echo "+++ Renaming the existing image file \"${IMAGE_FILE}\" to \"${BACKUP_FILE}\" ...."
  mv "${IMAGE_FILE}"  "${BACKUP_FILE}"
fi

echo "+++ Creating the file \"${IMAGE_FILE}\" ..."

${PREFIX} dd if=/dev/zero of=${IMAGE_FILE} bs=${BS_COUNT} count=${BS_SIZE} && \
  ${PREFIX} mkfs.ext3 "${IMAGE_FILE}" && \
  ${PREFIX} mkdir -p "${MOUNT_POINT}" && \
  ${PREFIX} sudo mount "${IMAGE_FILE}" "${MOUNT_POINT}" && \
  ${PREFIX} sudo cp -a -r image/*  "${MOUNT_POINT}" && \
  ${PREFIX} chcon -h -R "system_u:object_r:unlabeled_t:s0" "${MOUNT_POINT}/"*

  echo "\"${IMAGE_FILE}\" successfully created" && \
  THISRC=0

  if [ ${THISRC} = 0 ] ; then

    echo "+++ Modifying the permissions for the overlay direcories on the virtual disk ..."

    ${PREFIX} sudo mkdir -p "${MOUNT_POINT}/merged"
    ${PREFIX} sudo mkdir -p "${MOUNT_POINT}/upper"
    ${PREFIX} sudo mkdir -p "${MOUNT_POINT}/work"

    ${PREFIX} sudo chmod 777 "${MOUNT_POINT}/merged"
    ${PREFIX} sudo chmod 777 "${MOUNT_POINT}/upper"
    ${PREFIX} sudo chmod 777 "${MOUNT_POINT}/work"

    echo "+++ Setting up work directories with special permissions..."

    ${PREFIX} sudo mkdir -p  ${MOUNT_POINT}/work/system/work
    ${PREFIX} sudo chmod 777 ${MOUNT_POINT}/work
    ${PREFIX} sudo chmod 755 ${MOUNT_POINT}/work/system
    ${PREFIX} sudo chmod 0   ${MOUNT_POINT}/work/system/work 

    echo "+++ Setting file ownership to root..."
    ${PREFIX} sudo chown -R root:root ${MOUNT_POINT}/

    # Create script to display image version
    echo 'echo "# $( date +%s ) # Virtual disk created at $( date )"' | ${PREFIX} sudo tee ${MOUNT_POINT}/upper/system/bin/print_image_version >/dev/null
    ${PREFIX} sudo chmod 755 ${MOUNT_POINT}/upper/system/bin/print_image_version

    ${PREFIX} sudo umount "${MOUNT_POINT}" 
    ${PREFIX} rmdir "${MOUNT_POINT}"

    echo " ... all done; the image file is :"
    echo
    ls -l ${IMAGE_FILE}
    echo
  fi

  
  echo "Script ends with RC=${THISRC}"

exit ${THISRC}

