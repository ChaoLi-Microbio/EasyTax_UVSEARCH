#running in linux system
#Setting up working directory
wd={your data folder}
db={'db' folder}
PATH=$PATH:${db}/linux
cd ${wd}

mkdir -p result temp 

#put your metadata file into 'result' folder
cat -A result/metadata.txt | head -n3
# 1 sequencing data summary
ls -sh seq/
seqkit stat seq/*.fastq.gz > result/seqkit.txt
head result/seqkit.txt

# 2  Merge pair-end reads and rename
time for i in `tail -n+2 result/metadata.txt|cut -f1`;do
vsearch --fastq_mergepairs seq/${i}_R1_001.fastq.gz \
--reverse seq/${i}_R2_001.fastq.gz \
--fastqout temp/${i}.merged.fastq \
--relabel ${i}.
done &

# 3 Integrate renamed reads
cat temp/*.merged.fastq > temp/all.fastq
ls -lsh temp/all.fastq
head -n 6 temp/all.fastq|cut -c1-60

# 4 Cut primers and quality filter, Q20
time vsearch --fastx_filter temp/all.fastq \
--fastq_stripleft 19 --fastq_stripright 20 \
--fastq_maxee_rate 0.01 \
--fastaout temp/filtered.fa

head temp/filtered.fa

# 5 Dereplicate to the briefing for summary of rep tax
vsearch --derep_fulllength temp/filtered.fa \
--minuniquesize 10 --sizeout --relabel Uni_ \
--output temp/uniques.fa 

ls -lsh temp/uniques.fa
head -n 2 temp/uniques.fa

# 6 Denoise: predict biological sequences and filter chimeras
usearch -unoise3 temp/uniques.fa -minsize 10 \
-threads 14 \
-zotus temp/zotus.fa

# 7 unify names 
sed 's/Zotu/ASV_/g' temp/zotus.fa > temp/otus.fa
head -n 2 temp/otus.fa

mkdir -p result/raw
cp -f temp/otus.fa result/raw/otus.fa

# 8 Feature table (ASV)
time usearch -otutab temp/filtered.fa \
-id 1 \
-otus result/raw/otus.fa \
-threads 14 \
-otutabout result/raw/otutab.txt

###(Optional, just for big data process) 5.1 Feature table (ASV)
time vsearch --usearch_global temp/filtered.fa \
--db result/raw/otus.fa \
--id 1 \
--threads 0 \
--otutabout result/raw/otutab.txt 

#######################################
#Tax annotation
#Remove plastid and non-Bact, taxonomy annotation, assign different databases, gg2, slv138.1
vsearch --sintax result/raw/otus.fa \
--db ${db}/gg2.fa \
--sintax_cutoff 0.1 \
--tabbedout result/raw/otus.sintax 

sed -i 's/\r//' result/raw/otus.sintax
#list original otutable
wc -l result/raw/otutab.txt

#otutable.txt
#R remove colorplast/mitochondria and stat, output otutable filtered and rannked
Rscript ${db}/script/otutab_filter_nonBac.R \
--input result/raw/otutab.txt \
--taxonomy result/raw/otus.sintax \
--output result/otutab.txt \
--discard result/raw/otus.sintax.discard

wc -l result/otutab.txt
cut -f 1 result/otutab.txt | tail -n+2 > result/otutab.id

usearch -fastx_getseqs result/raw/otus.fa \
-labels result/otutab.id -fastaout result/otus.fa

awk 'NR==FNR{a[$1]=$0}NR>FNR{print a[$1]}' result/raw/otus.sintax result/otutab.id > result/otus.sintax

#Summary OTUs table
usearch -otutab_stats result/otutab.txt \
-output result/otutab.stat
cat result/otutab.stat

#OTU tree
usearch -cluster_agg result/otus.fa -treeout result/otus.tree

#Format OTU, tax annotation, 
cut -f 1,4 result/otus.sintax \
|sed 's/\td/\tk/;s/:/__/g;s/,/;/g;s/"//g' \
> result/taxonomy2.txt

#reformat01
awk 'BEGIN{OFS=FS="\t"}{delete a; a["k"]="Unassigned";a["p"]="Unassigned";a["c"]="Unassigned";a["o"]="Unassigned";a["f"]="Unassigned";a["g"]="Unassigned";a["s"]="Unassigned";\
      split($2,x,";");for(i in x){split(x[i],b,"__");a[b[1]]=b[2];} \
      print $1,a["k"],a["p"],a["c"],a["o"],a["f"],a["g"],a["s"];}' \
result/taxonomy2.txt > temp/otus.tax

#reformate02
sed 's/;/\t/g;s/.__//g;' temp/otus.tax|cut -f 1-8 | \
sed '1 s/^/OTUID\tKingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\n/' \
> result/taxonomy.txt

head -n3 result/taxonomy.txt
