# Task -- Downloading, Saving and Renaming Images downloaded from URL

# loading required libraries and the data

library(plyr)
library(readr)
library(dplyr)
library(caret)
library(readxl)

#===
#install.packages("jpeg")
#install.packages("here")
#install.packages("RCurl")
#install.packages("httr")
#install.packages("XML")

library(jpeg) #to read and write the images
library(here) #to save the files to the right location - this only works if you're working with a R project
library(curl)
library(RCurl)
library(httr)
library(XML)
setwd("PATH")  # add working directory here
getwd()
df <- read_excel("data.xlsx")  # importing data - type in the file name here
attach(df)
View(df)

#====
#Code to read one file and save it will look something like this:
myurl = "https://images.png"  # add image URL here
#Creating temporary place to save
z <- tempfile()
#Downloding the file
download.file(myurl,z,mode="wb")
#Reading the file from the temp object
pic <- readJPEG(z)
# cleanup
file.remove(z) 
#===

a = paste(df$f_name, df$l_name, sep=" ")

#b = paste(a,".jpg")

b = paste(a,".jpg", sep="")

df[2876,]
#Looped code 

for (i in 4071) { #change 100 with your number of rows to read through
  myurl <- paste(df[i,5], sep="") #you need the exact column number so change 1 to that value and change df to your dataframe's name
  z <- tempfile() #same as above
  tryCatch(download.file(myurl,z,mode="wb", method="curl"),silent=TRUE)
  pic <- readJPEG(z)
  writeJPEG(pic, paste(b[i], sep = ""))
  #alternatively you can do writeJPEG(pic, here("desired folder", paste("image", "i", ".jpg", sep = ""))
  #you can do setwd to the folder you want to write the files but here is much better
  #file.remove(z)
  
  i=+1
}

########################################################
########################################################
################# THE END ##############################
########################################################
########################################################