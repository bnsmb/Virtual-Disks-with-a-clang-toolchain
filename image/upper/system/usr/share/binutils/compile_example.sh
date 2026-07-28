
SOURCE_DIR=/system/usr/share/binutils

TARGET_DIR=/data/local/tmp


printf  " \n*** Compiling the source file \"${SOURCE_DIR}/helloworld_in_assembler_for_as.s\" to \"${TARGET_DIR}/helloworld_in_assembler_for_as\" ...\n\n"


rm -f ${TARGET_DIR}/helloworld_in_assembler_for_as.o ${TARGET_DIR}/helloworld_in_assembler_for_as 2>/dev/null

( set -x ; as  -o ${TARGET_DIR}/helloworld_in_assembler_for_as.o ${SOURCE_DIR}/helloworld_in_assembler_for_as.s && \
	ld -o ${TARGET_DIR}/helloworld_in_assembler_for_as ${TARGET_DIR}/helloworld_in_assembler_for_as.o  ) && \
  printf "\n*** Result: \n" && \
  ls -l ${TARGET_DIR}/helloworld_in_assembler_for_as && \
  printf "\n*** Now executing the test program \"${TARGET_DIR}/helloworld_in_assembler_for_as\" :\n\n" && \
  ${TARGET_DIR}/helloworld_in_assembler_for_as
  printf "\n"


