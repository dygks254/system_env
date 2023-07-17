#!/usr/bin/bash

if [[ $# -ne 1 ]]
then
	TEST_LIST=`ls -a | grep -E "\.[0-9]"`
else
	echo $1
	TEST_LIST=`ls -a | grep -E "$1"`
fi

if [ -e result.log ]
then
       rm result.log
fi

for i in $TEST_LIST
do
        if [ -e "./$i/status.log" ]
        then
                NOW_RESULT=`cat ./$i/status.log`
                grep "Time:" ./$i/sim.log -a > tmp.txt
                echo "TEST_CASE = $i" 
                echo "   |" 
	        echo "   |- RESULT : $NOW_RESULT" 
		sed -i 's/;/\n/g' tmp.txt
		sed -i 's/^ *//g' tmp.txt
		sed -i 's/   //g' tmp.txt
		while read -r line
		do
			echo "   |- $line" 
		done < tmp.txt
	else
	        echo "TEST_CASE = $i" 
	        echo "   |" 
	        echo "   |- RESULT : FAILED TIME OUT" 
	        echo "   |- Time: -" 
	        echo "   |- CPU Time: -" 
	        echo "   |- Data structure size: -" 
	fi
	echo "" 
done

if [ -e tmp.txt ]
then
	rm tmp.txt
fi
