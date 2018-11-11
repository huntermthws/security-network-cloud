#!/bin/bash
 
cd
#mkdir hash
cd hash
#wget https://hashcat.net/files_legacy/hashcat-2.00.7z
#7z e hashcat-2.00.7z
#./hashcat-cli64.bin -V
tail -n 1 /etc/shadow > crack1.hash
sed -i 's/.[^:]*:// ; s/\:.*$//' crack1.hash
curl https://samsclass.info/123/proj10/500_passwords.txt > 500_passwords.txt
./hashcat-cli64.bin -m 1800 -a 0 -o found1.txt --remove crack1.hash 500_passwords.txt
sed -i 's/.[^:]*://' found1.txt
head found1.txt