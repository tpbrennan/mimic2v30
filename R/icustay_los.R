filename = c("data/icustay_los.csv")
LOS = read.csv(paste(path,filename,sep="/"))
attach(LOS)
names(LOS)

hist(ICU_LOS)
summary(ICU_LOS)
LONGSTAYS = subset(LOS, ICU_LOS > 100) # 26 icustays
a = boxplot(ICU_LOS)
length(a$out) ## 5088 outliers
los = sort(ICU_LOS,decreasing=TRUE)
a = boxplot(los[1:100],main="Top 100 longest ICU stays",ylab="Length of Stay (days)")
length(a$out) ## 10 outliers
boxplot(a$out)
