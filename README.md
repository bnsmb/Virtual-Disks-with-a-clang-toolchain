# Virtual-Disks-with-a-clang-toolchain

This repository contains the files for a virtual disk with a **clang19 toolchain** for Android on devices with **arm64** CPUs, which can be used as an overlay mount.


<h2>Usage instructions</h2>

To use this virtual disk, **root** access is required on the phone.

To use one of the released images in this repository, execute these steps:

Download the **perl544_and_clang_virtual_image.gz** file from the releases; copy it to the phone to **/data/local/tmp** (or another writable directory), and uncompress the file.

If not already done, copy the script **create_overlay_mount.sh** to the phone (either from this repository or from the repository with scripts [https://github.com/bnsmb/scripts-for-Android](https://github.com/bnsmb/scripts-for-Android)) and make it executable.

**Note:**

The **version 1.4.1** or newer of the script **create_overlay_mount.sh** is required for this usage. 

Use the command
```
./create_overlay_mount.sh -V
```
to print the version of the script


To enable the overlay mount, open an adb shell and execute as user **root**:
```
/data/local/tmp/create_overlay_mount.sh IMAGE_FILE=/data/local/tmp/perl544_and_clang_virtual_image /system
```

**Example:**

<details>
<summary><b>/data/local/tmp/create_overlay_mount.sh IMAGE_FILE=/data/local/tmp/perl544_and_clang_virtual_image /system</b></summary>

 ```
/ASUS_I006D:/data/local/tmp $ time su - -c  /data/local/tmp/create_overlay_mount.sh 'IMAGE_FILE=/data/local/tmp/perl544_and_clang_virtual_image' /system
The image file "/data/local/tmp/perl544_and_clang_virtual_image" already exists - there should already be a filesystem on the disk
Mounting the imagefile "/data/local/tmp/perl544_and_clang_virtual_image" to "/dev/ov" ...
Now correcting the SELinux context for all files and directories in the directory "/dev/ov/upper" with the SELinux context "u:object_r:unlabeled:s0" to "u:object_r:system_file:s0" ...
This may take some minutes - please be patient 
... SELinux context for the files successfully modified

Creating and mounting the directories for the overlay mount for "/system" ...

Creating the overlay mount for "/system" ...
Creating the bind mount "/system"...
Checking the overlay mount for "/system" ...

Summary:
--------

1 overlay mount(s) created:

  /system

    0m03.48s real     0m00.01s user     0m00.01s system
ASUS_I006D:/data/local/tmp $ 
```
</details>

**Note:**

When a virtual disk with an overlay file system is used for the first time, the script **create_overlay_mount.sh** corrects the SELinux context of the files and directories on the disk. Depending on the number of files and directories on the disk, this may take some time.


Now the files from the virtual disk are available for all users in all shells with access to **/system** on the phone; examples:
```
ASUS_I006D:/ # perl --version

This is perl 5, version 44, subversion 0 (v5.44.0) built for aarch64-linux-android

Copyright 1987-2026, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at https://www.perl.org/, the Perl Home Page.


ASUS_I006D:/ # python --version
Python 3.14.0
ASUS_I006D:/ #


ASUS_I006D:/ # git --version
git version 2.53.0
ASUS_I006D:/ #
ASUS_I006D:/ #
```

To use the **clang** from the virtual disk image, the environment must be prepared (this command must run once in every adb session for using the **clang**):
```
source /bin/init_clang19_env 
```

**Example:**

<details>
<summary><b>source /bin/init_clang19_env</b></summary>

```
ASUS_I006D:/ # source /bin/init_clang19_env

Preparing the clang environment for creating binaries for the CPU type aarch64
The target root directory /data/local/tmp/develop/sysroot does not exist

Using clang 19                                                                            
Using the NDK /system/usr/ndk/r27b                                                         (environment variable NDK_DIR)
Using the sysroot directory /system/usr/ndk/r27b/sysroot                                   (environment variable SYSROOT)
Using the target root directory /data/local/tmp/develop/sysroot                            (environment variable TARGET_ROOT)


Environment variables used:


PATH is now:         /system/usr/clang19/bin:/product/bin:/apex/com.android.runtime/bin:/apex/com.android.art/bin:/apex/com.android.virt/bin:/system_ext/bin:/system/bin:/system/xbin:/odm/bin:/vendor/bin:/vendor/xbin

LD_LIBRARY_PATH:     :/system/usr/ndk/r27b/sysroot/usr/lib/aarch64-linux-android/:/system/usr/clang19/lib

API is now:          31
NDK_DIR is now:      /system/usr/ndk/r27b

SYSROOT is now:      /system/usr/ndk/r27b/sysroot

CFLAGS are now:       -I/system/usr/clang19/include -I/system/usr/ndk/r27b/include -I/system/usr/ndk/r27b/sysroot/usr/include --sysroot=/system/usr/ndk/r27b/sysroot

CPPFLAGS are now:     -I/system/usr/clang19/include -I/system/usr/ndk/r27b/include -I/system/usr/ndk/r27b/sysroot/usr/include

CXXFLAGS are now:     -I/system/usr/clang19/include -I/system/usr/ndk/r27b/include -I/system/usr/ndk/r27b/sysroot/usr/include --sysroot=/system/usr/ndk/r27b/sysroot

LDFLAGS are now:      -L/system/usr/ndk/r27b/sysroot/usr/lib/aarch64-linux-android/31 -L/system/usr/ndk/r27b/sysroot/usr/lib/aarch64-linux-android -B/system/usr/ndk/r27b/sysroot/usr/lib/aarch64-linux-android/31/ --sysroot=/system/usr/ndk/r27b/sysroot -lc
CC is now:           /system/usr/clang19/bin/clang
CXX is now:          /system/usr/clang19/bin/clang++
CPP is now:          /system/usr/clang19/bin/clang-cpp
CXXCPP is now:       /system/usr/clang19/bin/clang-cpp
AR is now:           /system/usr/clang19/bin/llvm-ar
AS is now:           /system/usr/clang19/bin/llvm-as
LD is now:           /system/usr/clang19/bin/lld
RANLIB is now:       /system/usr/clang19/bin/llvm-ranlib
STRIP is now:        /system/usr/clang19/bin/llvm-strip
PKG_CONFIG is now:   /system/usr/clang19/bin/pkg-config

TMP is now:          /data/local/tmp
Checking the clang binary ...

clang version 19.0.0git (https://android.googlesource.com/toolchain/llvm-project b3a530ec6537146650e42be89f1089e9a3588460)
Target: aarch64-unknown-linux-android
Thread model: posix
InstalledDir: /system/usr/clang19/bin

ASUS_I006D:/ #

```

</details>


Now the **clang** can be used :
```
ASUS_I006D:/ # clang --version
clang version 19.0.0git (https://android.googlesource.com/toolchain/llvm-project b3a530ec6537146650e42be89f1089e9a3588460)
Target: aarch64-unknown-linux-android
Thread model: posix
InstalledDir: /system/usr/clang19/bin
ASUS_I006D:/ #
```

Use the script **/system/bin/test_clang** to test the **clang** and **clang++** compiler, example:
```
ASUS_I006D:/ # /system/bin/test_clang

Testing the C compiler ...

Hello, World from a C program!
Compiled with Clang 19.0.0
Compiler version string: Clang 19.0.0git (https://android.googlesource.com/toolchain/llvm-project b3a530ec6537146650e42be89f1089e9a3588460)
NDK Version: r27.1
Target API Level (compiled for): 10000
Device API Level (runtime): 36

Testing the C++ compiler ...

Hello, World from a C++ program!
Compiled with Clang 19.0.0
Compiler version string: Clang 19.0.0git (https://android.googlesource.com/toolchain/llvm-project b3a530ec6537146650e42be89f1089e9a3588460)
NDK Version: r27.1
Target API Level (compiled for): 10000
Device API Level (runtime): 36

ASUS_I006D:/ #
```


To test the **clang assembler** execute this command:
```
cd /data/local/tmp/ &&  \
  clang -nostdlib -static -Wl,--entry=_start -o helloworld_in_assembler  /system/usr/share/as/helloworld_in_assembler_for_as.s  && ./helloworld_in_assembler
```

**Example:**
```
[clang19 vdisk env] ASUS_I006D:/data/local/tmp $ clang -nostdlib -static -Wl,--entry=_start -o helloworld_in_assembler  /system/usr/share/as/helloworld_in_assembler_for_as.s  && ./helloworld_in_assembler
Hello, World from an assembler program compiled with as and ld from the binutils!
[clang19 vdisk env] ASUS_I006D:/data/local/tmp $
```

To test the assembler **as** and the linker **ld** from the **GNU binutils** execute these commands:
```
cd /data/local/tmp/ &&  \
  /system/usr/bin/as -o ./helloworld_in_assembler_for_as.o /system/usr/share/as//helloworld_in_assembler_for_as.s && \
  /system/usr/bin/ld -o ./helloworld_in_assembler_for_as ./helloworld_in_assembler_for_as.o && \
  ./helloworld_in_assembler_for_as
```

Be aware, that **/system** is now writable for the user **root**. However, all new or modified files are stored in the virtual disk image and **NOT** in the real filesystem for **/system**. Therefore, you can add new files to the virtual disk by simply copying the files to **/system**. You can even delete files in **/system** (these files are also not really deleted in the original filesystem for **/system**, of course).

Keep in mind, that the free space on the virtual disk is only about **100 MB**.
Use the command
```
df -h /dev/ov
```
to check the free space in the virtual disk

The files on the virtual disk image are from these Magisk modules:
```
autoconf tools                 1.3.2.1
bash                           5.2.0_3-v1.1.1 `
binutils                       2.45-v1.0.0
bison_flex                     1.2.0
clang19                        19.0.0git-v1.2.3
cmake                          4.3.0-v1.0.0  
curl                           8.17.0-v1.0.0.0
DebugTools                     9.3.4.10
gdb17                          17.1_v1.0.0
git                            2.53.1-v1.1.0
man                            2.13-v1.0.0
myscripts                      1.4.19.0
openssl                        3.5.7-v1.1.0
perl544                        5.44.0-v1.1.1
python3                        3.14.v2.2.0
rsync                          3.4.4-v1.3.0
vim                            9.1.672
wget2                          2.2.0-v1.0.0.0
```
(see the [documentation for the Magisk modules](https://bnsmb.de/Magisk_Modules.html) for implementation details for the various tools)


**Trouble Shooting**

If a non-root user, such as **shell**, can no longer access the files in **/system/bin** after creating the overlay mount, you have most likely used an old version of the **create_overlay_mount.sh** script, and the SELinux context for the files in the overlay filesystem is incorrect.

If you still have a shell open with root access, you can fix this error with the following commands (in this order!):
```
 find /dev/ov/upper -context ‘u:object_r:unlabeled:s0’ -type l -print0 |
    xargs -0 chcon -h u:object_r:system_file:s0

 find /dev/ov/upper -context ‘u:object_r:unlabeled:s0’ -print0 |
    xargs -0 chcon u:object_r:system_file:s0
```
The **find** command modifies the files on the virtual disk and therefore only needs to be run once.

Another work around without modifying the files in the virtual disk image is to temporary disable SELinux by executing as user **root**:
```
setenforce 0
```

If you do not have a shell with **root** access open, you must restart the smartphone via the GUI on the phone.

However,  it's strongly recommended to update the script **create_overlay_mount.sh** to the current version to avoid errors like this in the future.

Files added in Android to the virtual disk are always created by the Android OS with a valid SELinux context.


**Notes**

In most cases, you'll need to reboot the phone to umount the overlay mount for **/system**.


The certificate file for **wget2**, **curl**, **git**, etc. in the virtual disk image, **/system/etc/security/ca-certificates.crt**, was created using the certificates in **/e/**. To recreate that file using the certificates on your phone, execute the command

```
/bin/create_certificate_file
```
as user **root**.

This command only needs to run once.


The environment for Perl programs is defined in the file **/system/bin/perl_env**. The default directory used for Perl Modules is **/system/usr/share/perl/lib/perl5**.


The file system on the virtual disk is **ext4**. To increase the capacity of the virtual disk, use the standard Linux commands on a PC to expand file systems.


To correct the SELinux context for the files and directories on the virtual disk without creating an overlay mount execute this command:
```
/data/local/tmp/create_overlay_mount.sh IMAGE_FILE=/data/local/tmp/perl544_and_clang_virtual_image --relabel mount_only
```
**Example:**
```
ASUS_I006D:/ $ su - -c /data/local/tmp/create_overlay_mount.sh IMAGE_FILE=/data/local/tmp/perl544_and_clang_virtual_image --relabel mount_only
The image file "/data/local/tmp/perl544_and_clang_virtual_image" already exists - there should already be a filesystem on the disk
Mounting the imagefile "/data/local/tmp/perl544_and_clang_virtual_image" to "/dev/ov" ...
Now correcting the SELinux context for all files and directories in the directory "/dev/ov/upper" with the SELinux context "u:object_r:unlabeled:s0" to "u:object_r:system_file:s0" ...
This may take some minutes - please be patient
... SELinux context for the files successfully modified

The virtual disk is mounted to "/dev/ov"

ASUS_I006D:/ $
```

To umount the virtual disk again execute this command.
```
su - -c /data/local/tmp/create_overlay_mount.sh clean
```

The documentation for the script **create_overlay_mount.sh** is [here](https://bnsmb.de/android/Documentation_for_the_script_create_overlay_mount.sh.html).


On phones without root access, you can use the [clang19 toolchain](https://bnsmb.de/Compiling_programs_for_Android.html#How_to_install_a_Toolchain_for_clang_on_phones_without_root_access) to install clang and the other tools necessary to compile C or C++ source files on the phone.

<hr></hr>

<a name="build_instructions">
<h2>Build instructions</h2>

To build your own virtual disk image, create a fork of this repository in GitHub and modify or add the files in that repository. When done, create a virtual disk image with the files in your repository using the Action "**Create Virtual Image with Ext4 Filesystem**" in the GitHub WebGUI. This action creates a new release with a virtual disk image with the current contents of the GitHub repository.


Or, if you you want to create the virtual disk local on your PC running Linux, execute these steps:

Clone the repository 
```
git clone https://github.com/bnsmb/Virtual-Disks-with-a-clang-toolchain.git
```
Change the working directory to the local git repository
```
cd Virtual-Disks-with-a-clang-toolchain/
```
add or modify the files in your local repository if necessary, and create the virtual disk image 
```
./create_virtual_disk.sh
```
The script creates the virtual disk in /tmp: **/tmp/perl544_and_clang_virtual_image**

You should only modify or add files in the directory **./image/upper/system** in the repository, this is the overlay for **/system** on the phone. Do **NOT** add files to the other directories in the repository.
To "delete" a file, create a character device with major=0 and minor=0 for that file in the directory **./upper/system**. E.g. to delete the file **/etc/hosts**:
```
mknod  ./dev/ov/upper/system/etc/hosts c 0 0                                                                                                                                              
```
