#!/system/bin/sh

GRANTED=$(magisk --sqlite "SELECT uid FROM policies WHERE policy = '2';")

echo 'Packages with root granted:'

for UID in $GRANTED
do
UID=$(echo $UID | sed 's!^uid=!!g')
pm list packages --uid $UID
done


