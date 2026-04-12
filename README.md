# Simplfied taxonomy analysis by U/VSEARCH (Linux)
## 6 public databases normalized (two versions of Greengenes, Silva and RDP)
Note: This simplified profiling pipline is based on USEARCH and VSEARCH(open-source version, data processing accelation), enabling quick, accessible and straightforward bacterial taxonomy based on 16S rRNA amplicon.
*Details please refer to [USEARCH](https://www.drive5.com/usearch/manual/cmds_all.html), [VSEARCH](https://github.com/torognes/vsearch) and [EazyAmplicon](https://github.com/YongxinLiu/EasyAmplicon.git).*

### All you need to do are: 
*(without miscellaneous environment deployment)*
#### 1. Download 'db' folder of this project
#### 2. Download reference database (gg2.fa and/or slv138.1.fa) from the release here, unzip, and put it into 'db' folder
*(Reference databases have been normalized fitting in the pipeline here, ready to use!)*
#### 3. Run 'u_vsearch(clean).sh' in the terminal step by step
*(Will generate taxonomy.txt and otutab.txt files. Either customize visualization on your preference or continue step 4 below)*

<br>

### Optional: Handy visualization
*(Refine/beautify your customized visualization is welcomed!)*
#### 4. Run 'visualization.R' step by step for taxonomy visualization (But first, Library/packages installation in R/R Studio!)
	install.packages("magrittr")
	install.packages("microeco")
	install.packages("ggplot2")
## Here you go and have fun!

## *Will post if any update for mac/win system

### Citation:
### If use this script, please cite the following:
"Database-Pipeline Interactions Shape Taxonomic Inference in 16S rRNA Microbial Community Profiling", 2026,  ISMECOMMUN-D-26-00272 (Under Review)









