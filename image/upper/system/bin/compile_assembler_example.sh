#!/system/bin/sh

__TRUE=0
__FALSE=1

CONT=${__TRUE}

SOURCE_DIR="/system/usr/share/as"
SOURCE_FILE="${SOURCE_DIR}/helloworld_in_assembler_for_as.s"

OBJECT_FILE="/data/local/tmp/helloworld_in_assembler_for_as.o"
TARGET_FILE="/data/local/tmp/helloworld_in_assembler_for_as"

echo "Compiling the assembler source file \"${SOURCE_FILE}\" to \"${TARGET_FILE}\" ..."

if [ ! -r ${SOURCE_FILE} ] ; then
  echo "ERROR: The source file \"${SOURCE_FILE}\" does not exist"
  exit 5
fi

for i in ${TARGET_FILE} ${OBJECT_FILE} ; do
  if [ -r $i ] ; then
    \rm -f $i 
    if [ $? -ne 0 ] ; then
      echo "ERROR: Can not delete the file \"$i\":"
      ls -l $i
      CONT=${__FALSE}
    fi
  fi
done
[ ${CONT} != ${__TRUE} ] && exit 5


as -o ${OBJECT_FILE} ${SOURCE_FILE} && \
  ld -o ${TARGET_FILE} ${OBJECT_FILE} && \
  ( echo "... success: " ; ls -l ${TARGET_FILE} ; set -x ; ${TARGET_FILE} )

