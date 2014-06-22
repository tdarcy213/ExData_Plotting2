## plot3.R - Use the EPA National Emissions data to build a plot that depicts
##           emissions over ten years in Baltimore, by type
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
## Create an object to summarize emissions in Baltimore by year and type
BaltEmisByType<-smryDT[fips=="24510",list(Total.Emissions=sum(Emissions)),by=list(year,type)]
## Open png graphics device
png(filename="plot3.png",width=720,height=720)
## Invoke ggplot to plot summarized data; utilize facets to present distinct plots for type
pBaltEmisByType<-ggplot(BaltEmisByType,aes(year,Total.Emissions,type))
pBaltEmisByType+geom_line(aes(color=type),size=2)+facet_wrap(~type)+labs(title="BALTIMORE EMISSIONS BY TYPE\n1999-2008")+geom_text(aes(label=Total.Emissions),hjust=0.5, vjust=1,size=2,color="blue4")
dev.off()