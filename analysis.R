## choose
noninteractive<-FALSE


readDivi <- function(){
g<-NULL
for(f in list.files("./data")){
    tmp<-read.csv(paste("./data",f,sep="/"),header=T)
    g<-unique(c(g,tmp$gemeindeschluessel))
}
divi.frei<-data.frame(gemeindeschluessel=g)
divi.belegt<-data.frame(gemeindeschluessel=g)
ng<-length(g)

for(f in list.files("./data")){
    tmp<-read.csv(paste("./data",f,sep="/"),header=T)
    divi.frei[[tmp$daten_stand[1]]]=rep(NA,ng)
    divi.belegt[[tmp$daten_stand[1]]]=rep(NA,ng)
    for(i in g){
        if(any(tmp$gemeindeschluessel==i)){
            divi.frei[[tmp$daten_stand[1]]][divi.frei$gemeindeschluessel==i]=tmp$betten_frei[tmp$gemeindeschluessel==i]
            divi.belegt[[tmp$daten_stand[1]]][divi.belegt$gemeindeschluessel==i]=tmp$betten_belegt[tmp$gemeindeschluessel==i]
        }
    }
}
list(frei=divi.frei,belegt=divi.belegt)
}

divi<-readDivi()
ng<-length(divi$frei$gemeindeschluessel)
library(readxl)
kreise <- read_excel("04-kreise.xlsx", 
                         sheet = "Tabelle2")
library(xts)
quot<-function(d,b){
    b<-try.xts(b)
    g<-try.xts(d)
    q<-b/g*100
    reclass(q, d)
}

if(!noninteractive) x11()
for(i in 1:ng){
    frei<-xts(as.numeric(cbind(divi[["frei"]][i,-1])),as.POSIXct(colnames(divi[["frei"]])[-1]))
    belegt<-xts(as.numeric(cbind(divi[["belegt"]][i,-1])),as.POSIXct(colnames(divi[["belegt"]])[-1]))
    zzz<-merge(frei+belegt,belegt)
    if(noninteractive)
        postscript(file=paste("./pdf/",divi[["frei"]]$gemeindeschluessel[i],".pdf",sep=""))
    print(
        plot(frei+belegt,main=paste("Gemeinde",divi[["frei"]]$gemeindeschluessel[i],kreise[as.numeric(kreise$gemeindeschluessel)==divi[["frei"]]$gemeindeschluessel[i],]$name),ylim=c(0,max(frei+belegt,na.rm=TRUE)))
        )
    print(
        lines(belegt,col="red")
    )
    print(
        addPanel(quot,b=belegt,main="Auslastung",ylim=c(0,100))
        )
    if(!noninteractive){
        readline(prompt="Press [enter] to continue")
        dev.copy2pdf(file=paste("./pdf/",divi[["frei"]]$gemeindeschluessel[i],".pdf",sep=""))
    } else {
        dev.off()
    }
}

#xxx<-xts(as.numeric(cbind(divi[["frei"]][10,-1])),as.POSIXct(colnames(divi[["frei"]])[-1]))
#plot(xxx,main=paste("Gemeinde",divi[["frei"]]$gemeindeschluessel[10]))

#i=233     
#frei<-xts(as.numeric(cbind(divi[["frei"]][i,-1])),as.POSIXct(colnames(divi[["frei"]])[-1]))
#belegt<-xts(as.numeric(cbind(divi[["belegt"]][i,-1])),as.POSIXct(colnames(divi[["belegt"]])[-1]))
#zzz<-merge(frei,belegt)
#plot(zzz,main=paste("Gemeinde",divi[["frei"]]$gemeindeschluessel[i]),multi.panel = 1)

#require(xtsExtra)  #if you get error, please install xtsExtra from r-forge as shown in the top line
#require(RColorBrewer)
