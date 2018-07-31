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
myExt='.vcf'
#find the ones that ran and are not empty, go into the folder where the job was run (subfolder of subfolder run)
find $(cat turbine-directory.txt )  -name \*"$myExt" -and -not -empty | wc
find $(cat turbine-directory.txt )  -name \*"$myExt" -and -not -empty >tmp
#find their corresponding input files, note that we are looking into the  "data" folder: this assumes that the file
#(or its folder) has the same name as the output file
for file in $(cat tmp); do grep $(basename $file | sed 's@'"$myExt"'@@') ${subjChrSweepRoot}/data/input.txt    ; done  >tmp1
#because of non unique naming there are some files that might be picked off twice, we need to eliminate those
sort tmp1 | uniq >tmp2
#find the ones that did not run
diff -u <(sort tmp2) <(sort ${subjChrSweepRoot}/data/input.txt) | grep -E "^\+"
