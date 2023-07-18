#!

find . -type d -name "soc-atom-s5" -exec git -C {} log --oneline -1 \; >> commit.log
