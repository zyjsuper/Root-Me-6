#!/bin/bash

## Prints the shellcode in little endian

RAW=$(objdump -d "$1" | grep "^ "|awk -F"[\t]" '{print $2}')
SHELLCODE=""
COUNT=0
for word in $RAW
do
	SHELLCODE=${SHELLCODE}${word:6:2}${word:4:2}${word:2:2}${word:0:2}
	((COUNT++))
done

echo $SHELLCODE | sed 's/ //g'| sed 's/.\{2\}/\\x&/g'|paste -d '' -s
echo "Shellcode size: ${COUNT} bytes"
