ADM = read.csv("/Users/tpb/Research/mimic2v30/data/hadm_dt.csv")

names(ADM)
hist(ADM$DT)
max(ADM$DT)
min(ADM$DT)
a = boxplot(ADM$DT)

summary(ADM$DT)
boxplot(a$out)

SDT = subset(ADM,abs(ADM$DT) < 5)
hist(SDT$DT,breaks=seq(-5,5,by=0.1),
     xlab="Time (days)",
     main="Histogram of time between ICU and Hospital Admission")
