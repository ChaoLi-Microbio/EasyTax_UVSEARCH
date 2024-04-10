# Simplfied taxonomy analysis by U/VSEARCH pipeline with Ref databases of gg2/slv138.1
## 6 versions of public databases normalized (gg2 and/or slv138.1 are recommended)
Note: This is the 16s amplicon dataset process adapted and briefed from EazyAmplicon(https://github.com/YongxinLiu/EasyAmplicon.git) using U/VSEARCH, targeting relatively precise identification of bacteria taxonomy.

Environment deployment:
1. Download 'db' folder of this project
2. Download gg2.fa and/or slv138.1.fa, put it into 'db' folder
3. Running 'u_vsearch(clean).sh' in terminal step by step
   (This step will yield taxonomy.txt and otutab.txt files, you can customize your taxon community or continue step 4 below)
5. Running 'visualization.R' step by step for taxonomy visualization
   (If necessary, library/packages installation:
   install.packages("BiocManager")
   BiocManager::install("devtools")
   install.packages("microeco")
   install.packages("ggplot2")
   install.packages("phyloseq")
   install.packages("magrittr")
   install.packages("igraph")
   install.packages("dplyr"))

There you go!








