#!/usr/bin/bash

TOP_LEVEL=$(git rev-parse --show-toplevel)
SRC_PATH="${TOP_LEVEL}/src"

CHECKING_LIST_FILE=`find ${SRC_PATH} -type f`
##CHECKING_LIST_REPO=`find ${SRC_PATH} -type d | grep -vi sdc`

echo "Start"

for i in ${CHECKING_LIST_FILE}; do
	RM_PATH=`echo "${i}" | sed -r 's/.+soc-rhea-s5//g'`
	# echo "--- NOW PATH ${RM_PATH}"
	if [[ "${RM_PATH}" =~ "sdc" ]]; then
		echo "in sdc file ${i}"
	else
		DIFF=`git diff HEAD origin/SDC .${RM_PATH}`
		if [ "${DIFF}" != "" ]; then
			echo "Change source file in ${i}"
			exit 1
		else
			echo "without change ${i}"
		fi
	fi
done

