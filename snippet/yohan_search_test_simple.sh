#!/usr/bin/bash

if [[ $# -ne 1 ]]
then
	TEST_LIST=`ls -a | grep -E "\.[0-9]"`
else
	echo $1
	TEST_LIST=`ls -a | grep -E "$1"`
fi

echo $TEST_LIST > test.log

if [ -e regr_result.log ]
then
       rm regr_result.log
fi

for i in $TEST_LIST
do
	echo $i
	if [ -e "./$i/status.log" ]
	then
		NOW_RESULT=`cat ./$i/status.log`
		echo "$i : $NOW_RESULT" >> regr_result.log
	else
		echo "$i : FAILED TIME OUT" >> regr_result.log
	fi
done

