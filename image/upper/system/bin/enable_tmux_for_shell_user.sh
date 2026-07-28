         echo "Enabling socket access for the user \"shell\"  (this is necessary to use tmux)..."

         su - -c magiskpolicy ' --live "allow shell shell_data_file sock_file { create getattr setattr write unlink }"  '
         su - -c magiskpolicy '--live "allow shell devpts chr_file { read write open }"'

