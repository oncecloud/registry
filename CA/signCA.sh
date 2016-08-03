#!/bin/bash
#Program:
#	sign CA
#Author:
#	cxxly
#History  :
#	2015/11/3 cxxly  first release
#Coypright:
#	ISCAS, ONCECloud Team
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Where is the crt saved
read -p "Plz input a path to save the certifacate:" crtDir

if [[ ! "$crtDir" =~ ^/.*[[:alnum:]]$ ]];then
    echo "$crtDir is the invalid path."
    echo "The Path should be such as '/path/to/somedir"
    exit 10
fi
#Where is the key saved
cakey=${cakey:-$crtDir/cakey.key}
#Where is the csr saved
csr=${csr:-$crtDir/certreq.csr}
#Where is the crt saved
crt=${crt:-$crtDir/cacert.crt}
#General a private key
if [ ! -d $crtDir ];then
mkdir -p $crtDir
else if [ ! -f $cakey ];then
        (umask 077; openssl genrsa -out $cakey 1024)
     fi
fi
#General .csr file
if [ ! -f $csr ];then
    openssl req -new -key $cakey -out $csr
fi
#Make the certficate
if [ ! -f $crt ];then
    retval=0
    openssl ca -in $csr -out $crt -days 3650
    [ $retval -nt 0 ] && echo "The certificate is created failure." && rm -f $crt
    echo "$crt is created successfully. It is placed in $crtDir."
else
    find $crt -size 0 | xargs rm -f
    echo "$crt is bad, try to create it again."
fi
