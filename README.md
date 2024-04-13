# Simplfied taxonomy analysis by U/VSEARCH
## 6 versions of public databases normalized (gg2 and/or slv138.1 are recommended)
Note: This is the 16s amplicon dataset process adapted and briefed from EazyAmplicon(https://github.com/YongxinLiu/EasyAmplicon.git) using U/VSEARCH, targeting relatively precise identification of bacteria taxonomy.

### All you need to do are:
#### 1. Download 'db' folder of this project
#### 2. Download gg2.fa and/or slv138.1.fa from the release, unzip, and then put it into 'db' folder
#### 3. Running 'u_vsearch(clean).sh' in terminal step by step
   (This step will yield taxonomy.txt and otutab.txt files, you can customize your taxon community or continue step 4 below)
#### 4. Running 'visualization.R' step by step for taxonomy visualization
   ##### But first, Library/packages installation in R!
   install.packages("magrittr")\
   install.packages("microeco")\
   install.packages("ggplot2")

### Have fun!








