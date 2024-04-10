#library
library(microeco)
library(ggplot2)
library(magrittr)

#
setwd("/home/data/result") # slv138.1, gg2

metadata = read.table("metadata.txt", header=T, row.names=NULL, sep="\t", comment.char="")
rownames(metadata) = metadata$SampleID
otutab = read.table("otutab.txt", header=T, row.names=1, sep="\t", comment.char="")
taxonomy = read.table("taxonomy.txt", header=T, row.names=1, sep="\t", comment.char="")

taxonomy %<>% tidy_taxonomy
metadata[,]

dataset = microtable$new(sample_table = metadata, otu_table = otutab, tax_table = taxonomy)
dataset$tidy_dataset()

dataset$tax_table %<>% base::subset(Kingdom == "k__Bacteria")
print(dataset)

dataset$filter_pollution(taxa = c("mitochondria", "chloroplast"))
print(dataset)

dataset$tidy_dataset()
print(dataset)
dataset$sample_sums() %>% range

dataset$cal_abund()
class(dataset$taxa_abund)

dir.create("tax", recursive=T)
dataset$save_abund(dirpath = "tax")


## Community Composition
# Define a vector of taxonomic ranks
taxonomic_ranks <- c("Phylum", "Class", "Order", "Family", "Genus", "Species")

#taxonomic_ranks <- c("Phylum", "Genus", "Species")
# Loop through the taxonomic ranks
for (rank in taxonomic_ranks) {
  # Calculate and plot for the current taxonomic rank
  t1 = trans_abund$new(dataset = dataset, taxrank = rank, ntaxa = 21)
  p = t1$plot_bar(others_color = "grey70", xtext_keep = TRUE, legend_text_italic = FALSE)
  
# Save the plot for the current taxonomic rank
ggsave(paste0("tax_", rank, ".pdf"), p)}
