onspd <- read.csv("./random-onspd-list.txt")
valid <- subset(onspd, is.na(onspd$doterm))
simple <- subset(valid, select=c("pcd", "pcon"))
results1729 <- simple

results1729$llsval <- sapply(simple$pcd, getLLS)
results1729$forgeval <- sapply(simple$pcd, getForge)
differences1729 <- subset(results1729, results1729$llsval != results1729$forgeval)
output <- as.matrix(results1729)
outputDiff <- as.matrix(differences1729)
write.table(output, file="./comparison1729.csv", sep=",")
write.table(outputDiff, file="./differences1729.csv", sep=",")
