ADM = read.csv("/Users/tpb/Research/mimic2v30/data/hadm_dt.csv")

names(ADM)
hist(ADM$DT)
max(ADM$DT)
min(ADM$DT)
a = boxplot(ADM$DT)

summary(ADM$DT)
boxplot(a$out)

SDT = subset(ADM,abs(ADM$DT) < 28)
boxplot(SDT$DT)
58758 - 57900
hist(SDT$DT,
     xlab="Time (days)",
     main="Histogram of time between ICU and Hospital Admission")
