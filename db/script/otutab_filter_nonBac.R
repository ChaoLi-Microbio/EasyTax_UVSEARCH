#!/usr/bin/env Rscript

# Functions:data files wrap-up, to remove redundant chloroplast, mitocondria, and non-bacteria from OTU & taxonomy tables for downstream analysis.

# Reference: Yong-Xin Liu, et al. A practical guide to amplicon and metagenomic analysis of microbiome data. Protein Cell 2021(12) 5:315-330 doi: 10.1007/s13238-020-00724-8

options(warn = -1) # Turn off warning

# R package installation
if (!suppressWarnings(suppressMessages(require("optparse", character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)))) {
    install.packages("optparse", repos=site)
    require("optparse",character.only=T)
}

if (TRUE){
    option_list = list(
        make_option(c("-i", "--input"), type="character", default="result/raw/otutab.txt",
                    help="OTU table [default %default]"),
        make_option(c("-t", "--taxonomy"), type="character", default="result/raw/otus.sintax",
                    help="sintax taxonomy [default %default]"),
        make_option(c("-s", "--stat"), type="character", default="result/raw/otutab_nonBac.stat",
                    help="Filter stat result [default %default]"),
        make_option(c("-d", "--discard"), type="character", default="result/raw/otus.sintax.discard",
                    help="Filter stat result [default %default]"),
        make_option(c("-o", "--output"), type="character", default="result/otutab.txt",
                    help="Filtered OTU table [default %default]")
    )
    opts = parse_args(OptionParser(option_list=option_list))
#    suppressWarnings(dir.create(opts$output))
}


# loaction of input files
# opts$input = "result/raw/otutab.txt"
# opts$taxonomy = "result/raw/otus.sintax"
# 
# loaction of output files
# opts$output = "result/otutab.txt"
# opts$stat = "result/raw/otutab_nonBac.txt"

otutab = read.table(opts$input, header=T, row.names=1, sep="\t", comment.char="")
sintax = read.table(opts$taxonomy, header=F, row.names=1, sep="\t", fill = TRUE, comment.char="")

print(paste0("Input feature table is ", opts$input))
print(paste0("Input sintax taxonomy table is ", opts$taxonomy))

total_reads = colSums(otutab)

# label nonspecific (non-bacteria and non-archaea)
idx = grepl("Bacteria|Archaea", sintax$V4, perl = T)
nonspecific = sintax[!idx,]
nonspecific_reads = colSums(otutab[rownames(nonspecific),])
sintax = sintax[idx,]

# label Chloroplast
idx = grepl("Chloroplast", sintax$V2, perl = T)
chloroplast = sintax[idx,]
chloroplast_reads = colSums(otutab[rownames(chloroplast),])
sintax = sintax[!idx,]

# label Mitochondria
idx = grepl("Mitochondria", sintax$V2, perl = T)
mitochondria = sintax[idx,]
mitochondria_reads = colSums(otutab[rownames(mitochondria),])
sintax = sintax[!idx,]

# otutab = otutab[rownames(sintax),]
idx = rownames(otutab) %in% rownames(sintax)
otutab = otutab[idx,]
idx = order(rowSums(otutab), decreasing = T)
otutab = otutab[idx,]
filtered_reads = colSums(otutab)

write.table(rbind(nonspecific, chloroplast, mitochondria), file=opts$discard, append = F, sep="\t", quote=F, row.names=T, col.names=F, eol = "\n")
df = as.data.frame(cbind(total_reads, nonspecific_reads, chloroplast_reads, mitochondria_reads, filtered_reads))
suppressWarnings(write.table(paste("SampleID\t",  sep=""), file=opts$stat, append = F, sep="\t", quote=F, row.names=F, col.names=F, eol = ""))
suppressWarnings(write.table(df, file=paste(opts$stat, sep=""), append = T, sep="\t", quote=F, row.names=T, col.names=T, eol = "\n"))

write.table(paste("#OTUID\t",  sep=""), file=paste(opts$output, sep=""), append = F, sep="\t", quote=F, row.names=F, col.names=F, eol = "")
suppressWarnings(write.table(otutab, file=paste(opts$output, sep=""), append = T, sep="\t", quote=F, row.names=T, col.names=T, eol = "\n"))

print(paste0("Summary of samples size in final feature table: "))
summary(filtered_reads)

print(paste0("Onput feature table is ", opts$output))
print(paste0("Detail and statistics in ", opts$stat))
