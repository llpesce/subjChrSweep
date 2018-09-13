#!/bin/bash
GATK=$1
input=$2
rootFileName=$(basename $input | sed 's/\.Recal\.bam//')
#rootFileName="${id}.${chr}.${GATK}"
id=${rootFileName:0:5}
chr=${rootFileName#*.}
output=${rootFileName}.alleles.vcf
log=${rootFileName}.alleles.log
#File without multiallelic, copy numbers and gene specific
if [ "$chr" == "chr11" ]; then
 alleleFile=/lustre/beagle2/averyrobinson/1000Genomes/Altered_Files/alt.${chr}.phase3.genotypes.noSVCN.noMULTI.MYBPC3.vcf.gz 
elif [ "$chr" == "chr14" ]; then
 alleleFile=/lustre/beagle2/averyrobinson/1000Genomes/Altered_Files/alt.${chr}.phase3.genotypes.noSVCN.noMULTI.MYH7.vcf.gz 
else
 alleleFile=/lustre/beagle2/averyrobinson/1000Genomes/Altered_Files/alt.${chr}.phase3.genotypes.noSVCN.noMULTI.TTR.vcf.gz 
fi
#File without multiallelic
#alleleFile=/lustre/beagle2/averyrobinson/1000Genomes/Altered_Files/alt.${chr}.phase3.genotypes.noSVCN.noMULTI.vcf.gz 
#alleleFile=/lustre/beagle2/averyrobinson/1000Genomes/Altered_Files/alt.${chr}.phase3.genotypes.noSV.noMULTI.vcf.gz
#File without structural variants
#alleleFile=/lustre/beagle2/lpesce/Megan/subjChrSweep/data/Genotype_given_alleles/alt.${chr}.phase3.genotypes.noSV.vcf.gz


module load sun-java/jdk1.8.0_60
#Reference needs to have index and dicitonary made
REF=/lustre/beagle2/lpesce/Megan/allCalls/ucsc.hg19.fasta

if [ "$GATK" == "3.7" ]; then
 
java -Xms4G -Xmx4G -jar /soft/gatk/3.7-0/GenomeAnalysisTK.jar \
-T HaplotypeCaller \
-I $input \
-o $output \
-R $REF \
-gt_mode GENOTYPE_GIVEN_ALLELES \
-alleles ${alleleFile} \
-XL chrM --output_mode EMIT_ALL_SITES \
-mbq 0 \
-L $alleleFile \
&> $log

else

/soft/gatk/4.0.3.0/gatk HaplotypeCaller \
--input $input \
--output $output \
--reference $REF \
--genotyping-mode GENOTYPE_GIVEN_ALLELES \
--alleles ${alleleFile} \
-XL chrM --output-mode EMIT_ALL_SITES \
--native-pair-hmm-threads 8 -L $alleleFile \
&> $log

fi
