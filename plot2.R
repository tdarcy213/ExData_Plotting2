## plot2.R - Use the EPA National Emissions data to build a plot that depicts
##           total emissions over ten years in Baltimore
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
## Create an object that summarizes emissions in Baltimore by year
BaltTotEmis<-smryDT[fips=="24510",list(Total.Emissions=sum(Emissions)),by=year]
## Open png graphic deviced
png(filename="plot2.png",width=480,height=480)
## Plot summarized data
with(BaltTotEmis,plot(year,Total.Emissions,type="l",xlab="year",ylab="Total Emissions",main="BALTIMORE EMISSIONS 1999-2008",lwd=4,col="aquamarine3"))
dev.off()