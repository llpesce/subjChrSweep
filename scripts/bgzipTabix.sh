#!/bin/bash
input=$1
rootFileName=$(basename $input | sed 's/\.vcf//')
id=${rootFileName:0:5}
chr=${rootFileName#*.}
output=${rootFileName}.vcf.gz
log=${rootFileName}.vcf.log

module load samtools

bgzip -c $input > $output 2>$log
tabix -p vcf $output >>$log 2>&1
md5sum $output > md5sum.txt
md5sum ${output}.tbi >> md5sum.txt
