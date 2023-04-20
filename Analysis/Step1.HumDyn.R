

## Sample code to extract sensor data into CSV files in MJFF data set
## contact Wen Dong (wendong@gmail.com) for technical questions

# ## this unzip all files
# path='/Volumes/RESEARCH/MJFF/MJFF-Data/'
# f = list.files(path, pattern='.zip$')
# for(i in 1:length(f)) unzip(file.path(path, f[i]), exdir= file.path(path, gsub('.zip', '', f[i])), unzip=getOption('unzip'))

mypath="~/Desktop/PBHLTH244/ProjectIII/Parkinson/MJFF-binary-files"
paths = list.dirs(mypath)
paths = paste0(paths, "/")

#path = '~/Desktop/HumDynLog_ORCHID_LGE_LGE_a0000028a92e71_20120223_120000_20120223_130000/'
for (path in paths[-1]){

if( which(path==paths) %% 100 == 0 ) print ( sprintf('%d/%d',which(path==paths), length(paths)-1))

f = list.files(path,patter='.bin')
f.info = file.info(file.path(path, f))
f.info$type = gsub('hdl_([a-z]+)_[[:print:]]+','\\1',f)
f.info$start.time = gsub('[[:print:]]+_([0-9]{8}_[0-9]{6}).bin','\\1',f)
f.info$start.time = strptime(f.info$start.time, format='%Y%m%d_%H%M%S')
ndx = which(f.info$size>0)
f.info=f.info[ndx,]
f = f[ndx]
if(length(ndx)==0) next

for (i in 1:nrow(f.info)){
	if(f.info$type[i]=='gps'){

		zz = file(file.path(path, f[i]), open='rb')
		s = readBin(zz, double(), n=f.info$size[i]/8, endian='big' )
		close(zz)
		s = matrix(s, ncol=4, byrow=TRUE)
		colnames(s) = c('diffSecs', 'latitude', 'longitude', 'altitude')
		
		s = as.data.frame(s)
		s = data.frame(s, time=f.info$start.time[i] + cumsum(s[,'diffSecs']))

		
		zz = bzfile(file.path(path, gsub('.bin', '.csv.bz2', f[i])), open='wt')
		write.csv(s, file=zz,row.names=FALSE)
		close(zz)
	} else if(f.info$type[i]=='audio'){

		zz = file(file.path(path, f[i]), open='rb')
		s = readBin(zz, single(), n=f.info$size[i]/4, size=4, endian='big' )
		close(zz)
		s = matrix(s, ncol=20, byrow=TRUE)
		colnames(s) = c('diffSecs', 'absolute.deviation', 'standard.deviation', 'max.deviation', paste('PSD',c(250,500,1000,2000), sep='.'), paste('MFCC', 1:12, sep='.'))
		s = as.data.frame(s)
		s = data.frame(s, time=f.info$start.time[i] + cumsum(s[,'diffSecs']))
		
		zz = bzfile(file.path(path, gsub('.bin', '.csv.bz2', f[i])), open='wt')
		write.csv(s, file=zz,row.names=FALSE)
		close(zz)
		
	} else if(f.info$type[i]=='accel'){

		zz = file(file.path(path, f[i]), open='rb')
		s = readBin(zz, single(), n=f.info$size[i]/4, size=4, endian='big' )
		close(zz)
		s = matrix(s, ncol=26, byrow=TRUE)
		colnames(s) = c('diffSecs', 'N.samples', c(t(outer(c('x','y','z'), c('mean', 'absolute.deviation', 'standard.deviation', 'max.deviation', paste('PSD',c(1,3,6,10), sep='.')), paste, sep='.'))) )
		s = as.data.frame(s)
		s = data.frame(s, time=f.info$start.time[i] + cumsum(s[,'diffSecs']))
		
		zz = bzfile(file.path(path, gsub('.bin', '.csv.bz2', f[i])), open='wt')
		write.csv(s, file=zz,row.names=FALSE)
		close(zz)
		
	} else if(f.info$type[i]=='prox'){
		zz = file(file.path(path, f[i]), open='rb')
		s = readBin(zz, single(), n=f.info$size[i]/4, size=4, endian='big' )
		close(zz)
		s = matrix(s, ncol=2, byrow=TRUE)
		colnames(s) = c('diffSecs', 'value' )
		s = as.data.frame(s)
		s = data.frame(s, time=f.info$start.time[i] + cumsum(s[,'diffSecs']))
		
		zz = bzfile(file.path(path, gsub('.bin', '.csv.bz2', f[i])), open='wt')
		write.csv(s, file=zz,row.names=FALSE)
		close(zz)
		
	} else if(f.info$type[i]=='light'){
		zz = file(file.path(path, f[i]), open='rb')
		s = readBin(zz, single(), n=f.info$size[i]/4, size=4, endian='big' )
		close(zz)
		s = matrix(s, ncol=2, byrow=TRUE)
		colnames(s) = c('diffSecs', 'value' )
		s = as.data.frame(s)
		s = data.frame(s, time=f.info$start.time[i] + cumsum(s[,'diffSecs']))
		
		zz = bzfile(file.path(path, gsub('.bin', '.csv.bz2', f[i])), open='wt')
		write.csv(s, file=zz,row.names=FALSE)
		close(zz)
		
	} else if(f.info$type[i]=='batt'){
		zz = file(file.path(path, f[i]), open='rb')
		s = readBin(zz, integer(), n=f.info$size[i]/2, size=2, signed=FALSE, endian='big' )
		close(zz)
		s = matrix(s, ncol=2, byrow=TRUE)
		colnames(s) = c('diffSecs', 'level' )
		s = as.data.frame(s)
		s = data.frame(s, time=f.info$start.time[i] + cumsum(s[,'diffSecs']))
		
		zz = bzfile(file.path(path, gsub('.bin', '.csv.bz2', f[i])), open='wt')
		write.csv(s, file=zz,row.names=FALSE)
		close(zz)
		
	} else if(f.info$type[i]=='cmpss'){
		zz = file(file.path(path, f[i]), open='rb')
		s = readBin(zz, single(), n=f.info$size[i]/4, size=4, endian='big' )
		close(zz)
		s = matrix(s, ncol=14, byrow=TRUE)
		colnames(s) = c('diffSecs', 'level', c(t(outer(c('azimuth','pitch','roll'), c('mean', 'absolute.deviation', 'standard.deviation', 'max.deviation' ), paste, sep='.'))) )
		s = as.data.frame(s)
		s = data.frame(s, time=f.info$start.time[i] + cumsum(s[,'diffSecs']))
		
		zz = bzfile(file.path(path, gsub('.bin', '.csv.bz2', f[i])), open='wt')
		write.csv(s, file=zz,row.names=FALSE)
		close(zz)
		
	}
	
}

invisible(file.remove(paste(path,"/",list.files(path)[-grep("csv",list.files(path))],sep="")))
}




