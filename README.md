# Simplfied taxonomy analysis by U/VSEARCH (Linux System)
## 6 public databases normalized (gg2 and/or slv138.1 are recommended)
Note: This is the 16s amplicon dataset process adapted and briefed from EazyAmplicon(https://github.com/YongxinLiu/EasyAmplicon.git) using U/VSEARCH, targeting straightforward and precise identification of bacteria taxonomy.

### All you need to do are(no other laborious environment deployment):
#### 1. Download 'db' folder of this project
#### 2. Download gg2.fa and/or slv138.1.fa from the release, unzip, and then put it into 'db' folder
#### 3. Run 'u_vsearch(clean).sh' in the terminal step by step
(This step will yield taxonomy.txt and otutab.txt files, you can customize your taxon community or continue step 4 below)
#### 4. Run 'visualization.R' step by step for taxonomy visualization
   ##### But first, Library/packages installation in R!
	install.packages("magrittr")
	install.packages("microeco")
	install.packages("ggplot2")
## Here you go, have fun!


### Citation:
### If use this script, please cite the following:
# Stay Tuned!









