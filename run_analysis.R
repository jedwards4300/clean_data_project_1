#create list of feature names
features <- read.table("features.txt")
feat_indx <- sort(c(agrep("mean()",features$V2),agrep("std()",features$V2)))
features <- gsub(c('-'),c(' '),features$V2)
features <- gsub(c('\\(\\)'),c(''),features)

#create list of activity labels
act_labels <- read.table("activity_labels.txt")

#combine training and test set 
X <- rbind(read.table("train//X_train.txt",col.names=features),read.table("test//X_test.txt",col.names=features))
y <- rbind(read.table("train//y_train.txt",col.names="activity"),read.table("test//y_test.txt",col.names="activity"))
subject <- rbind(read.table("train//subject_train.txt"),read.table("test//subject_test.txt"))

#convert activity ID (1-6) to activity description
y <- factor(y$activity,labels=act_labels$V2)

#combine X, y, and subjects into 1 data frame
X <- cbind(subject,y,X[,feat_indx])
names(X)[1:2] <- c("subject","activity")


#calculate averages over subjects and activities, and create tidy data set
Xmelt <- melt(X, id.vars=c("subject","activity"))
Xsum <- dcast(Xmelt, subject + activity ~ variable, fun.aggregate=mean)

#export to txt
write.table(Xsum,file="project1_tidy.txt")



