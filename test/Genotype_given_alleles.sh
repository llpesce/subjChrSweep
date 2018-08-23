#!/bin/bash
chr='chr22'
rootFileName=/lustre/beagle2/mjroy/NUgenomes/SS30052106223/06223
input=${rootFileName}.${chr}.Recal.bam
ID=$(basename $rootFileName)
output=${ID}.${chr}.alleles.vcf
log=${ID}.$chr.alleles.log
#File without multiallelic
alleleFile=/lustre/beagle2/averyrobinson/1000Genomes/Altered_Files/alt.chr22.phase3.genotypes.noSVCN.noMULTI.vcf.gz 
#alleleFile=/lustre/beagle2/averyrobinson/1000Genomes/Altered_Files/alt.${chr}.phase3.genotypes.noSV.noMULTI.vcf.gz
#File without structural variants
#alleleFile=/lustre/beagle2/lpesce/Megan/subjChrSweep/data/Genotype_given_alleles/alt.${chr}.phase3.genotypes.noSV.vcf.gz


module load sun-java/jdk1.8.0_60
#Reference needs to have index and dicitonary made
REF=/lustre/beagle2/lpesce/Megan/allCalls/ucsc.hg19.fasta

/soft/gatk/4.0.3.0/gatk HaplotypeCaller \
--input $input \
--output $output \
--reference $REF \
--genotyping-mode GENOTYPE_GIVEN_ALLELES \
--alleles ${alleleFile} \
-XL chrM --output-mode EMIT_ALL_SITES \
--native-pair-hmm-threads 8 -L $alleleFile \
&> $log

