## plot5.R - Use the EPA National Emissions data to build a plot that depicts
##           motor vehicle emissions in Baltimore over ten years
##
## Load data.table package
library(data.table)
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
## Create an object to summarize motor vehicle data for Baltimore
BaltMVEmis<-merge(smryDT[grepl("24510",fips),],mvSCC,by='SCC')[,list(Total.Emissions=sum(Emissions)),by=list(year,fips)]
## Open png graphic device
png(filename="plot5.png",width=480,height=480)
## Plot summarized data
with(BaltMVEmis[order(year)],plot(year,Total.Emissions,type="l",xlab="year",ylab="Total Emissions",main="BALTIMORE MOTOR VEHICLE EMISSIONS 1999-2008",lwd=4,col="darkblue"))
dev.off()