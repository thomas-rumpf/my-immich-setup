rsync -av -e "ssh -i /home/thomas/.ssh/id_rsa" --exclude-from='exclude.txt' thomas@192.168.2.2:/home/thomas/immich/ .
