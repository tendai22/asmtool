#! /bin/sh
cat "$@" |
sh c1.sh | tee x1.log |
sh c2.sh | tee x2.log |
sh c3.sh | tee x3.log |
sh c4.sh | tee x4.log