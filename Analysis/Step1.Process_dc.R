## clear everything in R 
rm(list=ls())

# get all paths in 'MJFF-binary-files' folder
mypath="~/Desktop/PBHLTH244/ProjectIII/Parkinson/MJFF-binary-files"
paths = list.dirs(mypath)
setwd(mypath)
#path = '~/Desktop/HumDynLog_ORCHID_LGE_LGE_a0000028a92e71_20120223_120000_20120223_130000/'
# initialize corresponding dataframe
light = list()


dc_count=1

for (path in paths){

  if(which(path==paths) %% 100 == 0 ) {
    print (sprintf('%d/%d',which(path==paths), length(paths), "dc_count=", 1))
    save(light, file=paste("light",dc_count,".Rdata",sep=""))
    if (which(path==paths) %% 500==0){
      dc_count=dc_count+1  
      light=list()
    } 
    }

f = list.files(path)
f.info = file.info(file.path(path, f))
## get some useful info via name
f.info$type = gsub('hdl_([a-z]+)_[[:print:]]+.csv','\\1',f)
# set whether this person has parkinson's or not
f.info$person = gsub('[[:print:]]+_([A-Z]+)_[[:print:]]+.csv','\\1',f)

if (identical(f,character(0))) {next}

for (i in 1:nrow(f.info)){
  if (f.info$person[i] %in% c("VIOLET", "DAISY", "CHERRY",
                              "CROCUS", "ORCHID", "PEONY", "IRIS", "FLOX", "MAPLE")){ f.info$PK[i] = 1
  }else{ f.info$PK[i] =0
  } 
}

f.info$start.time = gsub('[[:print:]]+_([0-9]{8}_[0-9]{6}).csv','\\1',f)
f.info$start.time = strptime(f.info$start.time, format='%Y%m%d_%H%M%S')
ndx = which(!is.na(f.info$start.time))
f.info=f.info[ndx,]
f = f[ndx]
if(length(ndx)==0) next

for (i in 1:nrow(f.info)){
  
  
	# if(f.info$type[i]=='gps'){
	# 
	#   s = data.frame(read.csv(paste0(path,'/',f[i]))) 
	#   PK=rep(f.info$PK[i],nrow(s))
	#   gps = rbind(gps,cbind(s, PK))
	#   
	# } else if(f.info$type[i]=='audio'){
	# 
	#   s = data.frame(read.csv(paste0(path,'/',f[i]))) 
	#   PK=rep(f.info$PK[i],nrow(s))
	#   audio = rbind(audio,cbind(s, PK))
	# 	
	# } else
	if(f.info$type[i]=='light'){

	  s = data.frame(read.csv(paste0(path,'/',f[i]))) 
	  PK=rep(f.info$PK[i],nrow(s))
	  person=rep(f.info$person[i],nrow(s))
	  light = rbind(light,cbind(s, PK, person))
	} 
  
  
#    else if(f.info$type[i]=='prox'){
# 	 
# 	  s = data.frame(read.csv(paste0(path,'/',f[i]))) 
# 	  PK=rep(f.info$PK[i],nrow(s))
# 	  prox = rbind(prox,cbind(s, PK))
# 	  
# 	} else if(f.info$type[i]=='light'){
# 		
# 	  s = data.frame(read.csv(paste0(path,'/',f[i]))) 
# 	  PK=rep(f.info$PK[i],nrow(s))
# 	  light = rbind(light,cbind(s, PK))
# 		
# 	} else if(f.info$type[i]=='batt'){
# 		
# 	  s = data.frame(read.csv(paste0(path,'/',f[i]))) 
# 	  PK=rep(f.info$PK[i],nrow(s))
# 	  batt = rbind(batt,cbind(s, PK))
# 		
# 	} else if(f.info$type[i]=='cmpss'){
# 		
# 	  s = data.frame(read.csv(paste0(path,'/',f[i]))) 
# 	  PK=rep(f.info$PK[i],nrow(s))
# 	  cmpss = rbind(cmpss,cbind(s, PK))
# 	  
# 	}
 }
}
save(light, file=paste("light",dc_count,".Rdata",sep=""))
# Finally, you will get seven dataframes, which are what you may need do analysis on.




