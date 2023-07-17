#!/usr/bin/bash

source /semifive/tools/Modules/default/init/zsh
module purge
module load synopsys/vcs/S-2021.09-SP2-1
module load synopsys/verdi/S-2021.09-SP2-1

COV_PATH=COVERAGE
COMPILE_PATH=build/compile/FULL
DUT_PATH=../../build/compile/FULL/coverage.vdb
CFG_PATH=../../soc-rhea-s5/templates/meta/cov/cov.cfg

COMMAND=$COV_PATH/merged_command
COVLOG=$COV_PATH/cov.log

if [ -e $COV_PATH ];then
	rm -rf $COV_PATH
fi
mkdir -p $COV_PATH
echo "" > test.log
echo "" > passed_case.log

echo "urg -dir \\" >> $COMMAND
echo "$DUT_PATH \\" >> $COMMAND

STATUS=`find  -name status.log`

for i in $STATUS
do
	STATUS_TEST=`cat $i`
	echo "$i $STATUS_TEST" >> test.log
#	sed -i 's/PASSED/ \\/' test.log
done

#echo "$i $STATUS_TEST" >> test.log
sed -i 's/\/status.log/\*\/coverage.vdb/g' test.log
PASSED_CASE=`sed -n '/PASSED/p' test.log`
echo $PASSED_CASE > passed_case.log
sed -i 's/PASSED//g' passed_case.log
PASSED_CASE=`cat passed_case.log`

for i in $PASSED_CASE
do
	echo "$i \\" >> $COMMAND
done

##echo "-grade index +urg+lic+wait -show tests \\" >> $COMMAND
echo "-metric tgl -tgl portsonly \\" >> $COMMAND
echo "-hier $CFG_PATH -log $COV_PATH/urg.log \\" >> $COMMAND
echo "-dbname $COV_PATH/merged.vdb \\" >> $COMMAND
echo "-report $COV_PATH/mergedReport" >> $COMMAND

bash $COMMAND 2>&1 | tee $COVLOG


rm test.log passed_case.log
