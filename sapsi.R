## CLEAR WORKSPACE
rm(list=ls())

## INPUT SAPSI
filename = c("data/sapsi_raw.csv")
path = c("/Users/tpb/Research/mimic2v30")
SAPSI = read.csv(paste(path,filename,sep="/"))


names(SAPSI)
attach(SAPSI)
DATA = subset(SAPSI,SEQ < 100)
attach(DATA)
hist(SEQ)

plot(SEQ,PARAM_COUNT)

#-------------------------------------------------------------------------
# COHORT

COHORT = subset(DATA,(DATA$LVEF_GROUP==3 | DATA$LVEF_GROUP==4))
attach(COHORT)

SURVIVORS = subset(COHORT,MORTALITY_28D==0)
attach(SURVIVORS)

#-------------------------------------------------------------------------
# TABLE 1.A - NORMAL VS. HYPERDYNAMIC

source(paste(path,'R/table1.R',sep='/'))

#-------------------------------------------------------------------------
# TABLE 2.A: HYPERDYNAMIC - LOGISTIC REGRESSION MODEL

source(paste(path,'R/mregr_hdlvef.R',sep='/'))

#-------------------------------------------------------------------------
# TABLE 2.B: HYPERDYNAMIC LESS CHF & HYPERTENSIVE - LOGISTIC REGRESSION MODEL

source(paste(path,'R/mregr_hdlvef-subgroup.R',sep='/'))

#-------------------------------------------------------------------------
# TABLE 3: HYPERDYNAMIC COHORTS VS. SEPTIC 

source(paste(path,'R/sepsis_hdlvef.R',sep='/'))

#-------------------------------------------------------------------------
# TABLE 4: SEPSIS COHORT OUTCOMES

source(paste(path,'R/mregr_sepsis.R',sep='/'))

#-------------------------------------------------------------------------
# TABLE 4.A: HYPERDYNAMIC COX REGRESSION MODEL of ONE-YEAR MORTALITY

source(paste(path,'R/hazard_survivors.R',sep='/'))

#-------------------------------------------------------------------------
# TABLE 4.B: HYPERDYNAMIC COX REGRESSION MODEL of ONE-YEAR MORTALITY

source(paste(path,'R/hazard_survivors-subgroup.R',sep='/'))
