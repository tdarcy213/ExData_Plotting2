## plot4.R - Use the EPA National Emissions data to build a plot that depicts
##           US Coal Emissions over a ten year period
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
## Index for source data pertaining to Coal Emissions
coalSCC<-srcDT[
        grepl("coal",srcDT$SCC.Level.One,ignore.case=T)|
                grepl("coal",srcDT$SCC.Level.Two,ignore.case=T)|
                grepl("coal",srcDT$SCC.Level.Three,ignore.case=T)|
                grepl("coal",srcDT$SCC.Level.Four,ignore.case=T)
        ,]
## Create an object to summarize US Coal Emissions
USCoalEmis<-merge(smryDT,coalSCC,by='SCC')[,list(Total.Emissions=sum(Emissions)),by=year]
## Open png graphic device
png(filename="plot4.png",width=480,height=480)
## Plot summarized data
with(USCoalEmis,plot(year,Total.Emissions,type="l",xlab="year",ylab="Total Emissions",main="US COAL EMISSIONS 1999-2008",lwd=4,col="aquamarine3"))
dev.off()