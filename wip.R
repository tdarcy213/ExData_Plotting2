setwd("C:/Users/Tim/Desktop/Coursera/Exploratory Data Analysis/Course Project #2")
library(data.table)
srcDT<-data.table(readRDS("Source_Classification_Code.rds"))
smryDT<-data.table(readRDS("summarySCC_PM25.rds"))
mvSCC<-srcDT[
        grepl("vehicle",srcDT$SCC.Level.One,ignore.case=T)|
                grepl("vehicle",srcDT$SCC.Level.Two,ignore.case=T)|
                grepl("vehicle",srcDT$SCC.Level.Three,ignore.case=T)|
                grepl("vehicle",srcDT$SCC.Level.Four,ignore.case=T)
        ,]
coalSCC<-srcDT[
        grepl("coal",srcDT$SCC.Level.One,ignore.case=T)|
                grepl("coal",srcDT$SCC.Level.Two,ignore.case=T)|
                grepl("coal",srcDT$SCC.Level.Three,ignore.case=T)|
                grepl("coal",srcDT$SCC.Level.Four,ignore.case=T)
        ,]
USTotEmis<-smryDT[,list(Total.Emissions=sum(Emissions)),by=year]
with(USTotEmis,plot(year,Total.Emissions,type="l",xlab="year",ylab="Total Emissions",main="US EMISSIONS 1999-2008",lwd=4,col="aquamarine3"))
BaltTotEmis<-smryDT[fips=="24510",list(Total.Emissions=sum(Emissions)),by=year]
with(BaltTotEmis,plot(year,Total.Emissions,type="l",xlab="year",ylab="Total Emissions",main="BALTIMORE EMISSIONS 1999-2008",lwd=4,col="aquamarine3"))
BaltEmisByType<-smryDT[fips=="24510",list(Total.Emissions=sum(Emissions)),by=list(year,type)]
library(ggplot2)
pBaltEmisByType<-ggplot(BaltEmisByType,aes(year,Total.Emissions,type))
pBaltEmisByType+geom_line(aes(color=type),size=2)+facet_wrap(~type)+labs(title="BALTIMORE EMISSIONS BY TYPE\n1999-2008")+geom_text(aes(label=Total.Emissions),hjust=0.5, vjust=1,size=2,color="blue4")
USCoalEmis<-merge(smryDT,coalSCC,by='SCC')[,list(Total.Emissions=sum(Emissions)),by=year]
with(USCoalEmis,plot(year,Total.Emissions,type="l",xlab="year",ylab="Total Emissions",main="US COAL EMISSIONS 1999-2008",lwd=4,col="aquamarine3"))
BaltLosAngMVEmis<-merge(smryDT[grepl("06037|24510",fips),],mvSCC,by='SCC')[,list(Total.Emissions=sum(Emissions)),by=list(year,fips)]
BaltLosAngMVEmis$city<-factor(BaltLosAngMVEmis$fips,labels=c("Los Angeles","Baltimore"))
pBaltLosAngMVEmis<-ggplot(BaltLosAngMVEmis,aes(x=year,y=Total.Emissions,fill=city))
##pBaltLosAngMVEmis+geom_bar(color="black",stat="identity",position=position_dodge())+geom_line(fill="black",size=2)+labs(title="MOTOR VEHICLE EMISSIONS LOS ANGELES VS. BALTIMORE 1999-2008")
##pBaltLosAngMVEmis+geom_bar(color="black",stat="identity",position=position_dodge())+geom_line(fill="black",size=2)+geom_text(aes(label=Total.Emissions),hjust=0, vjust=0)+ggtitle(expression(atop("MOTOR VEHICLE EMISSIONS 1999-2008", atop(italic("LOS ANGELES VS. BALTIMORE"), ""))))
pBaltLosAngMVEmis+geom_bar(color="black",stat="identity",position=position_dodge())+geom_line(fill="black",size=2)+geom_text(aes(label=Total.Emissions),hjust=0, vjust=2,size=3,color="blue4")+ggtitle(expression(atop("MOTOR VEHICLE EMISSIONS 1999-2008", atop(italic("LOS ANGELES VS. BALTIMORE"), ""))))+xlab("YEAR")+ylab("TOTAL EMISSIONS")



