#!/bin/bash
#Program:
#	make CA
#Author:
#	cxxly
#History  :
#	2015/11/3 cxxly  first release
#Coypright:
#	ISCAS, ONCECloud Team
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#set CA directory
dir=${dir:-/etc/pki/CA}
certs=${certs:-$dir/certs}
crl_dir=${crl_dir:-$dir/crl}
private_key_dir=${private_key_dir:-$dir/private}
new_certs_dir=${new_certs_dir:-$dir/newcerts}

#file related to self-signed certs
database=${database:-$dir/index.txt}
serial=${serial:-$dir/serial}
crlnumber=${crlnumber:-$dir/crlnumber}

#private key (root)
private_key=${private_key:-$private_key_dir/cakey.pem}

#self-signed certs
certificate=${certificate:-$dir/cacert.pem}

#generate CA
makeCA() {
    [ ! -d $dir ] && mkdir -p $dir
    [ ! -d $private_key_dir ]  && mkdir -p $private_key_dir
    # create private key
    if [ ! -f $private_key ];then
        (umask 077; openssl genrsa -out $private_key 2048)
    fi
    # generate self-signed cert
    if [ ! -f $certificate ];then
        openssl req -new -x509 -key $private_key -out $certificate -days 3650
    fi

    [ ! -d $certs -a ! -d $crl_dir -a ! -d $new_certs_dir ] && mkdir -p $certs $crl_dir $new_certs_dir

    touch $database $serial $crlnumber  && echo 01 > $serial
}

makeCA

echo "Generate CA successfully.The newCA is $new_certs_dir."
