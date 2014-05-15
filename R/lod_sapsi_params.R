## CLEAR WORKSPACE
rm(list=ls())

## INPUT SAPSI
filename = c("data/sapsi_lod_paramcnt.csv")

## LOAD DATA
path = c("/Users/tpb/Research/mimic2v30")
paste(path,filename,sep="/")
DATA = read.csv(paste(path,filename,sep="/"))

#-------------------------------------------------------------------------
# LOD_PARAMCNT

names(DATA)
plot(DATA$LOD,DATA$PARAM_COUNT)


names(SAPSI)
attach(SAPSI)
DATA = subset(SAPSI,SEQ < 100)
attach(DATA)
hist(SEQ)

FIRSTDAY = subset(DATA,SEQ == 1)
hist(FIRSTDAY$PARAM_COUNT)
plot(SEQ,PARAM_COUNT)
