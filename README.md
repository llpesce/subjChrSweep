EMEWS project template
-----------------------

You have just created an EMEWS project.

This project is compatible with swift-t v. 1.3+. Earlier
versions will NOT work.

The project consists of the following directories:

```
SNPEFF/
  data/
  ext/
  etc/
  python/
    test/
  R/
    test/
  scripts/
  swift/
  README.md
```
The directories are intended to contain the following:

 * `data` - model input etc. data
 * `etc` - additional code used by EMEWS
 * `ext` - swift-t extensions such as eqpy, eqr
 * `python` - python code (e.g. model exploration algorithms written in python)
 * `python/test` - tests of the python code
 * `R` - R code (e.g. model exploration algorithms written R)
 * `R/test` - tests of the R code
 * `scripts` - any necessary scripts (e.g. scripts to launch a model), excluding
    scripts used to run the workflow.
 * `swift` - swift code

Use the subtemplates to customize this structure for particular types of
workflows. These are: sweep, eqpy, and eqr.

Usage
SWIFT_T=/soft/swift-t/compute/SAVI-2018-01-31
PATH=$SWIFT_T/stc/bin:$PATH
PATH=$SWIFT_T/turbine/bin:$PATH
run as
subjChrSweepRoot=$(pwd) #When run from the folder where this README.md is
${subjChrSweepRoot}/swift/swift_run_sweep.sh test

to rerun broken ones:
#Assuming that the input would a vcf file
myExt='.vcf.idx'
#find the ones that ran and are not empty, go into the folder where the job was run (subfolder of subfolder run)
find $(cat turbine-directory.txt )  -name \*"$myExt" -and -not -empty | wc
#Check the log file for completion statements
find $(cat turbine-directory.txt )  -name \*".alleles.log" -exec grep -l "ProgressMeter -            done" {} \;> complete.log
find $(cat turbine-directory.txt )  -name \*"$myExt" -and -not -empty >tmp
#compare the to files 
diff <(sed 's/\.log//' complete.log) <(sed 's/\.vcf\.idx//' tmp) 
#find the input files that already ran
#WARNING HARCODED INPUT FILE!!
inputFile=${subjChrSweepRoot}/data/input.txt_2
for file in $(cat tmp); do tmp=$(dirname $file); chr=$(basename $tmp); ID=$(basename $(dirname $tmp)); grep $ID $inputFile | grep -w $chr ; done  >tmp2
#find their corresponding input files, note that we are looking into the  "data" folder: this assumes that the file
#(or its folder) has the same name as the output file
#for file in $(cat tmp); do grep $(basename $file | sed 's@'"$myExt"'@@') ${subjChrSweepRoot}/data/input.txt    ; done  >tmp1
#because of non unique naming there are some files that might be picked off twice, we need to eliminate those
#sort tmp1 | uniq >tmp2
#find the ones that did not run
diff -u <(sort tmp2) <(sort $inputFile) | grep -E "^\+" | sed 's/^\+//'
# Hack away the "+", remove first line and shove into new input 
#Clean the run directory from failed and exploded runs
find $(cat turbine-directory.txt )  -name \*"alleles.log" -exec grep -L "ProgressMeter -            done" {} \;> incomplete.log
#Check that such files in fact do not have an idx file -- no return means there is no such file
sed 's/\.log/\.vcf\.idx/' incomplete.log | xargs ls {} 2>/dev/null
#Remove incomple files
for file in $(cat incomplete.log); do rm $(dirname $file)/* ; done
#rerun with new input file

#To find the total size of the vcf files
find ../experiments/GENOTYPE_ALL_[1,2]  -name \*".alleles.vcf" -exec du -ch {} + >VCFsize.txt
grep total$ VCFsize.txt | cut -f1 | awk '{ total += $1 }; END { print total }'

#Update the repo
eval "$(ssh-agent -s)"
ssh-add  ~/.ssh/id_github
git push

