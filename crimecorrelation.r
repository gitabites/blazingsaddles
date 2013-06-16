#Step 1: load & process data

#load & store data
data <- read.csv("guncrime_2011.csv", header=T)
unemp <- read.csv("stateunemp2011.csv", header=T)
seri <- read.csv("seri2011.csv", header=T)

#resort seri to be alphabetically ordered
attach(seri)
seri <- seri[order(State),]

#drop third column of unemp
unemp1 <- unemp[,c("State", "Unemployment.rate")]

#merge unemp1 and seri1
whycrime <- merge(seri, unemp)

#drop last 4 rows of data
data <- head(data, -4L)

#rename column 4 to "firearm_deaths"
names(data)[4] <- "firearm_deaths"

#keep only the State and firearm_deaths columns from data
data <- data[,c("State", "firearm_deaths")]

#remove Alabama and Florida rows from whycrime (missing from data)
whycrime <- whycrime[c(-1, -9),]

#remove DC from data (missing from whycrime)
data <- data[c(-8),]

#merge data and why crime
whycrime1 <- merge(whycrime, data)

#transform firearm_deaths from factor to numeric
whycrime1 <- transform(whycrime1, firearm_deaths = as.numeric(firearm_deaths))


#Part 2: Visualize data

#load ggplot2
library(ggplot2)

firearm_seri <- ggplot(data=whycrime1)+ aes(x=firearm_deaths, y=SERI.index, color=State)+ geom_text(aes(label=State)) 

firearm_unemp <- ggplot(data=whycrime1)+ aes(x=firearm_deaths, y=Unemployment.rate, color=State)+ geom_text(aes(label=State)) 

firearm_seri <- firearm_seri+ xlab("Firearm Deaths 2011") + ylab("SERI Index") + ggtitle("Firearm deaths and SERI Index per state, 2011")

firearm_unemp <- firearm_unemp + xlab("Firearm Deaths 2011") + ylab("Unemployment Rate") + ggtitle("Firearm deaths and unemployment rate per state, 2011")

firearm_seri <- firearm_seri + theme(legend.position="none") 

firearm_unemp <- firearm_unemp + theme(legend.position="none")

 