#!/bin/bash

read -p "Enter username: " username
read -p "Enter file name (id_rsa): " rsa_file
read -p "Enter passphrase: " passphrase

ssh-keygen -t rsa -b 4096 -f $rsa_file -P $passphrase -C $username
puttygen $rsa_file -O private -o $rsa_file.ppk
puttygen $rsa_file.ppk -O private-openssh -o $rsa_file.pem
zip -r $rsa_file.zip $rsa_file $rsa_file.ppk $rsa_file.pem
echo "Content public rsa:"
echo "---- BEGIN ----"
cat $rsa_file.pub
echo "---- END ----"
rm -rf $rsa_file $rsa_file.pub $rsa_file.ppk $rsa_file.pem
