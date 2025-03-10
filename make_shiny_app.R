library(Seurat)
library(scRNAseqApp)

# create shiny app
args = commandArgs(trailingOnly=TRUE)
directory <- args[1]
object <- args[2]
project_name <- args[3]
modality <- args[4]
setwd(directory)
seurat <- readRDS(object)

dir.create(paste0(directory,'scRNAseqAPP'), showWarnings = F)
dir.create(paste0(directory,'scRNAseqAPP/data'), showWarnings = F)
publish_folder=paste0(directory,'scRNAseqAPP/')
appconf <- createAppConfig(
  title=project_name,
  species = 'Homo sapiens',
  destinationFolder = project_name,
  datatype = modality)
createDataSet(appconf, seurat, datafolder=paste0(publish_folder, "/data"))
scInit(app_path=publish_folder, overwrite = T)

# write script to load app
sc_shiny_app_run<-file(paste0(directory,"sc_shiny_app_run.R"))
writeLines(c("library(Seurat)",
             "library(scRNAseqApp)",
             paste0('setwd','("',directory,'")'),
             "publish_folder='scRNAseqAPP/'"), 
           sc_shiny_app_run)
close(sc_shiny_app_run)