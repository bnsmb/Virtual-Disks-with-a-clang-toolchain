#!/system/bin/sh
#
#h# correct_selinux_contexts.sh - correct the SELinux context for files with invalid SELinux context in a directory
#h#
#h# Usage:
#h# 
#h# correct_selinux_contexts.sh [directory]
#h# 
#h# The parameter "directory" is optional; the default for this parameter is "/system"
#h# 
# History
#   01.08.2026 /bs
#     initial release
#


__TRUE=0
__FALSE=1

THISRC=${__FALSE}

TARGET_DIR="$1"

TARGET_DIR="${TARGET_DIR:=/system}"

 UNLABELED_SELINUX_CONTEXT="${UNLABELED_SELINUX_CONTEXT:=*:unlabeled*:*}"
UNLABELED_SELINUX_CONTEXT1="${UNLABELED_SELINUX_CONTEXT1:=*:default*:*}"


CUR_USER=$( id -un )

case $1 in 
  -h | --help | help )
    grep "^#h#" $0 | cut -c4-
    exit 0
    ;;
esac

NEW_SELINUX_CONTEXT="$( stat -c %C "${TARGET_DIR}" )"

if [ ${CUR_USER}x != "root"x ] ; then
  echo "ERROR: This script must be run by the user \"root\" "
  THISRC=${__FALSE}
elif [ ! -d "${TARGET_DIR}" ] ;then
  echo "ERROR: The directory \"${TARGET_DIR}\" does not exist"
  THISRC=${__FALSE}
else    

    echo "Now correcting the SELinux context for all files and directories with the SELinux context \"${UNLABELED_SELINUX_CONTEXT}\" or \"${UNLABELED_SELINUX_CONTEXT1}\" in the directory \"${TARGET_DIR}\" to \"${NEW_SELINUX_CONTEXT}\" ..."
    echo  "This may take some minutes - please be patient "

     find "${TARGET_DIR}"  -type l \( -context "${UNLABELED_SELINUX_CONTEXT}" -o -context "${UNLABELED_SELINUX_CONTEXT1}" \) -print0 2>/dev/null |  xargs -0 -r ${PREFIX} chcon -h "${NEW_SELINUX_CONTEXT}" || \
      THISRC=${__FALSE}
 
     find "${TARGET_DIR}"          \( -context "${UNLABELED_SELINUX_CONTEXT}" -o -context "${UNLABELED_SELINUX_CONTEXT1}" \) -print0 | xargs -0 -r ${PREFIX} chcon -h "${NEW_SELINUX_CONTEXT}" || \
      THISRC=${__FALSE}
fi
exit ${THISRC}

