#!/bin/bash

F=/tmp/tmp_file.txt

touch $F
chmod 777 $F
./ch12
cat $F
