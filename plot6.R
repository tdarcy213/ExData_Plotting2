## plot6.R - Use the EPA National Emissions data to build a plot that compares
##           motor vehicle emissions over ten years in Los Angeles vs. Baltimore
##
## Load data.table and ggplot packages
library(data.table)
library(ggplot2)
## If "Source" and "Summary Data Tables" are not cached, invoke readRDS funtion to load data
if(exists("srcDT")==FALSE){
srcDT<-data.table(readRDS("Source_Classification_Code.rds"))
}
if(exists("smryDT")==FALSE){
smryDT<-data.table(readRDS("summarySCC_PM25.rds"))
}
## Index for source data pertaining to Motor Vehicles
mvSCC<-srcDT[
        grepl("vehicle",srcDT$SCC.Level.One,ignore.case=T)|
                grepl("vehicle",srcDT$SCC.Level.Two,ignore.case=T)|
                grepl("vehicle",srcDT$SCC.Level.Three,ignore.case=T)|
                grepl("vehicle",srcDT$SCC.Level.Four,ignore.case=T)
        ,]
## Create an object to summarize motor vehicle data for Los Angeles and Baltimore
BaltLosAngMVEmis<-merge(smryDT[grepl("06037|24510",fips),],mvSCC,by='SCC')[,list(Total.Emissions=sum(Emissions)),by=list(year,fips)]
BaltLosAngMVEmis$city<-factor(BaltLosAngMVEmis$fips,labels=c("Los Angeles","Baltimore"))
## Open png graphic device
png(filename="plot6.png",width=960,height=480)
## invoke ggplot to plot summarized data
pBaltLosAngMVEmis<-ggplot(BaltLosAngMVEmis[order(fips,year)],aes(x=year,y=Total.Emissions,fill=city))
pBaltLosAngMVEmis+geom_bar(color="black",stat="identity",position=position_dodge())+geom_line(fill="black",size=2)+geom_text(aes(label=Total.Emissions),hjust=0, vjust=2,size=3,color="blue4")+ggtitle(expression(atop("MOTOR VEHICLE EMISSIONS 1999-2008", atop(italic("LOS ANGELES VS. BALTIMORE"), ""))))+xlab("YEAR")+ylab("TOTAL EMISSIONS")
dev.off()


