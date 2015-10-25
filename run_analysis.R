library(data.table)
library(dplyr)
library(reshape2)

trainx<-data.table(read.table("./Project/UCI HAR Dataset/train/X_train.txt", quote="\""))
train_lab<-data.table(read.table("./Project/UCI HAR Dataset/train/y_train.txt", quote="\""))
testx<-data.table(read.table("./Project/UCI HAR Dataset/test/X_test.txt", quote="\""))
test_lab<-data.table(read.table("./Project/UCI HAR Dataset/test/y_test.txt", quote="\""))

activity_labels <- read.table("./Project/UCI HAR Dataset/activity_labels.txt", quote="\"")
subject_train <- read.table("./Project/UCI HAR Dataset/train/subject_train.txt", quote="\"")
subject_test <- read.table("./Project/UCI HAR Dataset/test/subject_test.txt", quote="\"")
features <- read.table("./Project/UCI HAR Dataset/features.txt", quote="\"")

names(trainx)<-as.character(features$V2)
names(testx)<-as.character(features$V2)

data1<-rbind(trainx,testx)
data1$label<-rbind(train_lab,test_lab)
data1$label<-factor(data1$label,label=activity_labels$V1)
data1$type<-c(rep("train",nrow(trainx)),rep("test",nrow(testx)))
data1$subject<-rbind(subject_train,subject_test)

data2<-data1[,grep("mean|std.*[A-Z]$",names(data1)),with=F]
data2<-data.table(subject=data1$subject,label=data1$label,data2)

for(i in 1:6){
  for(j in 1:30){
    if(i==1 & j==1){
      a<-apply(data2%>%filter(subject==j , label==i),2,mean)
    }else{
      b<-apply(data2%>%filter(subject==j, label==i),2,mean)
      a<-rbind(a,b)  
    }  
  }
  
}

a<-data.frame(a)
a$label<-factor(a$label,label=activity_labels$V2)

write.table(a,file="./Project/data3.txt",row.name=F)
