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
h = hist(DATA$SAPSI_FIRST,breaks=seq(0,40,by=2))

popmort=100*sum(DATA$HOSPITAL_EXPIRE_FLG)/nrow(DATA)
newmort = numeric(0)
oldmort = numeric(0)
for ( i in seq(0,38,by=2) ) {
  NEWSAPSI = subset(DATA,DATA$SAPSI_FIRST>=i & DATA$SAPSI_FIRST<i+5)
  newmort = c(newmort, sum(NEWSAPSI$HOSPITAL_EXPIRE_FLG)/nrow(NEWSAPSI))

  OLDSAPSI = subset(DATA,DATA$OLD_SAPSI_FIRST>=i & DATA$OLD_SAPSI_FIRST<i+5)
  oldmort = c(oldmort, sum(OLDSAPSI$HOSPITAL_EXPIRE_FLG)/nrow(OLDSAPSI))
  
}
pdf(paste(path,'figure/fig_sapsi_mort.pdf',sep='/'))
plot(h$mids,oldmort,col='red',xaxt='n',yaxt='n',xlab='',ylab='')
par(new=TRUE)
plot(h$mids,newmort,col="blue",ylab="Hospital Mortality (%)",xlab="SAPS-I First")
legend('topleft',fill=c("red","blue"),
       bty='n',c('MIMIC2V26','MIMIC2V30'))
dev.off()


boxplot(DATA$SAPSI_FIRST~DATA$HOSPITAL_EXPIRE_FLG,
        xlab='Hospital Mortality',
        ylab='SAPS-I First')

boxplot(DATA$OLD_SAPSI_FIRST~DATA$HOSPITAL_EXPIRE_FLG,
        xlab='Hospital Mortality',
        ylab='SAPS-I First')

#-------------------------------------------------------------------------
# SAPSI_COMPARE - ERROR

FIRST_SAPSI_ERROR = DATA$SAPSI_FIRST - DATA$OLD_SAPSI_FIRST
s=summary(FIRST_SAPSI_ERROR)
N=sum(!is.na(FIRST_SAPSI_ERROR))
merr=mean(FIRST_SAPSI_ERROR,na.rm=T)
iqrerr=IQR(FIRST_SAPSI_ERROR,na.rm=T)
label = sprintf('SAPS-I Error (%.2f +/- %.0f)',merr,iqrerr)
title=sprintf('First SAPS-I Error (N=%.0f)',N)
pdf(paste(path,'figure/fig_hist_sapsi_first_err.pdf',sep='/'))
hist(FIRST_SAPSI_ERROR,main=title,xlab=label)
dev.off()

MAX_SAPSI_ERROR = DATA$SAPSI_MAX - DATA$OLD_SAPSI_MAX
s=summary(MAX_SAPSI_ERROR)
N=sum(!is.na(MAX_SAPSI_ERROR))
merr=median(MAX_SAPSI_ERROR,na.rm=T)
iqrerr=IQR(MAX_SAPSI_ERROR,na.rm=T)
label = sprintf('SAPS-I Error (%.0f +/- %.0f)',merr,iqrerr)
title=sprintf('Max SAPS-I Error (N=%.0f)',N)
pdf(paste(path,'figure/fig_hist_sapsi_max_err.pdf',sep='/'))
hist(MAX_SAPSI_ERROR,main=title,xlab=label)
dev.off()

MIN_SAPSI_ERROR = DATA$SAPSI_MIN - DATA$OLD_SAPSI_MIN
s=summary(MIN_SAPSI_ERROR)
N=sum(!is.na(MIN_SAPSI_ERROR))
merr = median(MIN_SAPSI_ERROR,na.rm=T)
iqrerr = IQR(MIN_SAPSI_ERROR,na.rm=T)
label = sprintf('SAPS-I Error (%.0f +/- %.0f)',merr,iqrerr)
title=sprintf('Min SAPS-I Error (N=%.0f)',N)
pdf(paste(path,'figure/fig_hist_sapsi_min_err.pdf',sep='/'))
hist(MIN_SAPSI_ERROR,main=title,xlab=label)
dev.off()

#-------------------------------------------------------------------------
# HISTOGRAM SAPSI - FIRST

summary(DATA$SAPSI_FIRST)
N=sum(!is.na(DATA$SAPSI_FIRST))
merr = median(DATA$SAPSI_FIRST,na.rm=T)
iqrerr = IQR(DATA$SAPSI_FIRST,na.rm=T)
label = sprintf('MIMIC2v30 First SAPS-I (%.0f +/- %.0f)',merr,iqrerr)
title=sprintf('MIMIC2v30 First SAPS-I (N=%.0f)',N)
pdf(paste(path,'figure/fig_hist_sapsi_first_mimic2v30.pdf',sep='/'))
hist(DATA$SAPSI_FIRST,main=title,xlab=label,breaks=seq(0,42,2))
dev.off()

summary(DATA$OLD_SAPSI_FIRST)
N=sum(!is.na(DATA$OLD_SAPSI_FIRST))
merr = median(DATA$OLD_SAPSI_FIRST,na.rm=T)
iqrerr = IQR(DATA$OLD_SAPSI_FIRST,na.rm=T)
label = sprintf('MIMIC2v26 First SAPS-I (%.0f +/- %.0f)',merr,iqrerr)
title=sprintf('MIMIC2v26 First SAPS-I (N=%.0f)',N)
pdf(paste(path,'figure/fig_hist_sapsi_first_mimic2v26.pdf',sep='/'))
hist(DATA$OLD_SAPSI_FIRST,main=title,xlab=label,breaks=seq(0,42,2))
dev.off()

#-------------------------------------------------------------------------
# HISTOGRAM SAPSI - MIN

summary(DATA$SAPSI_MIN)
N=sum(!is.na(DATA$SAPSI_MIN))
merr = median(DATA$SAPSI_MIN,na.rm=T)
iqrerr = IQR(DATA$SAPSI_MIN,na.rm=T)
label = sprintf('MIMIC2v30 Min SAPS-I (%.0f +/- %.0f)',merr,iqrerr)
title=sprintf('MIMIC2v30 Min SAPS-I (N=%.0f)',N)
pdf(paste(path,'figure/fig_hist_sapsi_min_mimic2v30.pdf',sep='/'))
hist(DATA$SAPSI_MIN,main=title,xlab=label,breaks=seq(0,42,2))
dev.off()

summary(DATA$OLD_SAPSI_MIN)
N=sum(!is.na(DATA$OLD_SAPSI_MIN))
merr = median(DATA$OLD_SAPSI_MIN,na.rm=T)
iqrerr = IQR(DATA$OLD_SAPSI_MIN,na.rm=T)
label = sprintf('MIMIC2v26 Min SAPS-I (%.0f +/- %.0f)',merr,iqrerr)
title=sprintf('MIMIC2v26 Min SAPS-I (N=%.0f)',N)
pdf(paste(path,'figure/fig_hist_sapsi_min_mimic2v26.pdf',sep='/'))
hist(DATA$OLD_SAPSI_MIN,main=title,xlab=label,breaks=seq(0,42,2))
dev.off()


#-------------------------------------------------------------------------
# HISTOGRAM SAPSI - MAX

summary(DATA$SAPSI_MAX)
N=sum(!is.na(DATA$SAPSI_MAX))
merr = median(DATA$SAPSI_MAX,na.rm=T)
iqrerr = IQR(DATA$SAPSI_MAX,na.rm=T)
label = sprintf('MIMIC2v30 Max SAPS-I (%.0f +/- %.0f)',merr,iqrerr)
title=sprintf('MIMIC2v30 Max SAPS-I (N=%.0f)',N)
pdf(paste(path,'figure/fig_hist_sapsi_max_mimic2v30.pdf',sep='/'))
hist(DATA$SAPSI_MAX,main=title,xlab=label,breaks=seq(0,42,2))
dev.off()

summary(DATA$OLD_SAPSI_MAX)
N=sum(!is.na(DATA$OLD_SAPSI_MAX))
merr = median(DATA$OLD_SAPSI_MAX,na.rm=T)
iqrerr = IQR(DATA$OLD_SAPSI_MAX,na.rm=T)
label = sprintf('MIMIC2v26 Max SAPS-I (%.0f +/- %.0f)',merr,iqrerr)
title=sprintf('MIMIC2v26 Max SAPS-I (N=%.0f)',N)
pdf(paste(path,'figure/fig_hist_sapsi_max_mimic2v26.pdf',sep='/'))
hist(DATA$OLD_SAPSI_MAX,main=title,xlab=label,breaks=seq(0,42,2))
dev.off()

