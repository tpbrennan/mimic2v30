## CLEAR WORKSPACE
rm(list=ls())

## INPUT SAPSI
filename = c("data/sapsi_compare.csv")

## LOAD DATA
path = c("/Users/tpb/Research/mimic2v30")
paste(path,filename,sep="/")
DATA = read.csv(paste(path,filename,sep="/"))

names(DATA)

#-------------------------------------------------------------------------
# SAPSI_COMPARE - MORTALITY

s = summary(DATA$SAPSI_FIRST)
h = hist(DATA$SAPSI_FIRST,breaks=seq(0,50,by=5))

popmort=100*sum(DATA$HOSPITAL_EXPIRE_FLG)/nrow(DATA)
newmort = numeric(0)
oldmort = numeric(0)
for ( i in seq(0,45,by=5) ) {
  NEWSAPSI = subset(DATA,DATA$SAPSI_FIRST>=i & DATA$SAPSI_FIRST<i+5)
  newmort = c(newmort, sum(NEWSAPSI$HOSPITAL_EXPIRE_FLG)/nrow(NEWSAPSI))

  OLDSAPSI = subset(DATA,DATA$OLD_SAPSI_FIRST>=i & DATA$OLD_SAPSI_FIRST<i+5)
  oldmort = c(oldmort, sum(OLDSAPSI$HOSPITAL_EXPIRE_FLG)/nrow(OLDSAPSI))
  
}

plot(h$mids,newmort,col='red',xaxt='n',yaxt='n')
par(new=TRUE)
plot(h$mids,oldmort,col="blue",
     ylab="Hospital Mortality (%)",
     xlab="SAPS-I First")

#-------------------------------------------------------------------------
# SAPSI_COMPARE - ERROR

FIRST_SAPSI_ERROR = DATA$SAPSI_FIRST - DATA$OLD_SAPSI_FIRST
s=summary(FIRST_SAPSI_ERROR)
N=length(FIRST_SAPSI_ERROR) - s[7]
merr=mean(FIRST_SAPSI_ERROR,na.rm=T)
iqrerr=IQR(FIRST_SAPSI_ERROR,na.rm=T)
label = sprintf('SAPS-I Error (%.2f +/- %d)',merr,iqrerr)
title=sprintf('First SAPS-I Error (N=%d)',N)
pdf(paste(path,'figure/fig_hist_sapsi_first_err.pdf',sep='/'))
hist(FIRST_SAPSI_ERROR,main=title,xlab=label)
dev.off()

MAX_SAPSI_ERROR = DATA$SAPSI_MAX - DATA$OLD_SAPSI_MAX
s=summary(MAX_SAPSI_ERROR)
N=length(MAX_SAPSI_ERROR) - s[7]
merr=median(MAX_SAPSI_ERROR,na.rm=T)
iqrerr=IQR(MAX_SAPSI_ERROR,na.rm=T)
label = sprintf('SAPS-I Error (%d +/- %d)',merr,iqrerr)
title=sprintf('Max SAPS-I Error (N=%d)',N)
pdf(paste(path,'figure/fig_hist_sapsi_max_err.pdf',sep='/'))
hist(MAX_SAPSI_ERROR,main=title,xlab=label)
dev.off()

MIN_SAPSI_ERROR = DATA$SAPSI_MIN - DATA$OLD_SAPSI_MIN
s=summary(MIN_SAPSI_ERROR)
N=length(MIN_SAPSI_ERROR) - s[7]
merr = median(MIN_SAPSI_ERROR,na.rm=T)
iqrerr = IQR(MIN_SAPSI_ERROR,na.rm=T)
label = sprintf('SAPS-I Error (%d +/- %d)',merr,iqrerr)
title=sprintf('Min SAPS-I Error (N=%d)',N)
pdf(paste(path,'figure/fig_hist_sapsi_min_err.pdf',sep='/'))
hist(MIN_SAPSI_ERROR,main=title,xlab=label)
dev.off()

#-------------------------------------------------------------------------
# HISTOGRAM SAPSI - FIRST

summary(DATA$SAPSI_FIRST)
N=length(DATA$SAPSI_FIRST)
merr = median(DATA$SAPSI_FIRST,na.rm=T)
iqrerr = IQR(DATA$SAPSI_FIRST,na.rm=T)
label = sprintf('MIMIC2v30 First SAPS-I (%d +/- %d)',merr,iqrerr)
title=sprintf('MIMIC2v30 First SAPS-I (N=%d)',N)
pdf(paste(path,'figure/fig_hist_sapsi_first_mimic2v30.pdf',sep='/'))
hist(DATA$SAPSI_FIRST,main=title,xlab=label)
dev.off()

summary(DATA$OLD_SAPSI_FIRST)
N=length(DATA$OLD_SAPSI_FIRST)
merr = median(DATA$OLD_SAPSI_FIRST,na.rm=T)
iqrerr = IQR(DATA$OLD_SAPSI_FIRST,na.rm=T)
label = sprintf('MIMIC2v26 First SAPS-I (%d +/- %d)',merr,iqrerr)
title=sprintf('MIMIC2v26 First SAPS-I (N=%d)',N)
pdf(paste(path,'figure/fig_hist_sapsi_first_mimic2v26.pdf',sep='/'))
hist(DATA$OLD_SAPSI_FIRST,main=title,xlab=label)
dev.off()

#-------------------------------------------------------------------------
# HISTOGRAM SAPSI - MIN

summary(DATA$SAPSI_MIN)
N=length(DATA$SAPSI_MIN)
merr = median(DATA$SAPSI_MIN,na.rm=T)
iqrerr = IQR(DATA$SAPSI_MIN,na.rm=T)
label = sprintf('MIMIC2v30 Min SAPS-I (%d +/- %d)',merr,iqrerr)
title=sprintf('MIMIC2v30 Min SAPS-I (N=%d)',N)
pdf(paste(path,'figure/fig_hist_sapsi_min_mimic2v30.pdf',sep='/'))
hist(DATA$SAPSI_MIN,main=title,xlab=label)
dev.off()

summary(DATA$OLD_SAPSI_MIN)
N=length(DATA$OLD_SAPSI_MIN)
merr = median(DATA$OLD_SAPSI_MIN,na.rm=T)
iqrerr = IQR(DATA$OLD_SAPSI_MIN,na.rm=T)
label = sprintf('MIMIC2v26 Min SAPS-I (%d +/- %d)',merr,iqrerr)
title=sprintf('MIMIC2v26 Min SAPS-I (N=%d)',N)
pdf(paste(path,'figure/fig_hist_sapsi_min_mimic2v26.pdf',sep='/'))
hist(DATA$OLD_SAPSI_MIN,main=title,xlab=label)
dev.off()


#-------------------------------------------------------------------------
# HISTOGRAM SAPSI - MAX

summary(DATA$SAPSI_MAX)
N=length(DATA$SAPSI_MAX)
merr = median(DATA$SAPSI_MAX,na.rm=T)
iqrerr = IQR(DATA$SAPSI_MAX,na.rm=T)
label = sprintf('MIMIC2v30 Max SAPS-I (%d +/- %d)',merr,iqrerr)
title=sprintf('MIMIC2v30 Max SAPS-I (N=%d)',N)
pdf(paste(path,'figure/fig_hist_sapsi_max_mimic2v30.pdf',sep='/'))
hist(DATA$SAPSI_MAX,main=title,xlab=label)
dev.off()

summary(DATA$OLD_SAPSI_MAX)
N=length(DATA$OLD_SAPSI_MAX)
merr = median(DATA$OLD_SAPSI_MAX,na.rm=T)
iqrerr = IQR(DATA$OLD_SAPSI_MAX,na.rm=T)
label = sprintf('MIMIC2v26 Max SAPS-I (%d +/- %d)',merr,iqrerr)
title=sprintf('MIMIC2v26 Max SAPS-I (N=%d)',N)
pdf(paste(path,'figure/fig_hist_sapsi_max_mimic2v26.pdf',sep='/'))
hist(DATA$OLD_SAPSI_MAX,main=title,xlab=label)
dev.off()

