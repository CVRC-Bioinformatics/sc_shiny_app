library(Seurat)
library(scRNAseqApp)

# create shiny app
sample_table <- read.table('samples.txt', sep = '\t', header = T)
directory <- getwd()
dir.create(paste0(directory,'/scRNAseqAPP'), showWarnings = F)
dir.create(paste0(directory,'/scRNAseqAPP/data'), showWarnings = F)
publish_folder=paste0(directory,'/scRNAseqAPP/')

for(i in 1:nrow(sample_table)){
  seurat <- readRDS(sample_table$object_path[i])
  appconf <- createAppConfig(
    title=sample_table$object_name[i],
    species = sample_table$species[i],
    destinationFolder = sample_table$object_name[i],
    datatype = sample_table$modality[i])
  createDataSet(appconf, seurat, datafolder=paste0(publish_folder, "/data"))
}
scInit(app_path=publish_folder, overwrite = T)

# write script to load app
sc_shiny_app_run<-file(paste0(directory,"/sc_shiny_app_run.R"))
writeLines(c("library(Seurat)",
             "library(scRNAseqApp)",
             paste0('setwd','("',directory,'")'),
             "publish_folder='scRNAseqAPP/'"), 
           sc_shiny_app_run)
close(sc_shiny_app_run)
