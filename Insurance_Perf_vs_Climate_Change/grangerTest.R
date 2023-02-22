rm(list=ls()) # remove all variables in workspace to ensure there are no conflicting variables.

# loading important and necessary libraries
library(outliers)  # useful for outlier detection tests
library(gridExtra) # gridExtra package provides helpful function for multi-object layout
library(ggplot2)   # powerful for producing beautiful data visualizations
library(forecast)  # useful for providing methods and tools for displaying and analysing univariate time series
library(lmtest)    # useful for cointegration and causality tests
library(vars)      # useful for selecting
library(tseries)   # useful for augmented Dickey-Fuller Test
library(urca)      # useful package for cointegration

# get working directory
getwd()

# IMPORTING DATASETS INTO R
# Global climate data (temperature) 
clim_data <- read.csv("Confirmed_Global_Land_Ocean_Temp.csv", sep = ",")

# Global climate data (ocean heat content)
clim_data2 <- read.csv("oceanHeatContent1993-2019.csv", sep = ",")

# Regional climate data (temperature) 
asia_temp <- read.csv("asia_land_temp.csv", sep = ",")
europe_temp <- read.csv("europe_land_temp.csv", sep = ",")
north_america_temp <- read.csv("north_america_land_temp.csv", sep = ",")
oceania_temp <- read.csv("oceania_land_temp.csv", sep = ",")

# U.S. Climate Extremes Index (CEI)
# Contiguous U.S. Without Tropical Cyclone Indicator
cont_us_cei <- read.csv("contiguous_US_CEI.csv", sep=",")

# Regional insurance claims data
asia_claims_data <- read.csv("asia_preprocessed_claims.csv", sep = ",")
europe_claims_data <- read.csv("europe_preprocessed_claims.csv", sep = ",")
north_america_claims_data <- read.csv("north_america_preprocessed_claims.csv", sep = ",")
oceania_claims_data <- read.csv("oceania_preprocessed_claims.csv", sep = ",")

# Regional insurance premiums data
asia_premiums_data <- read.csv("asia_preprocessed_premiums.csv", sep = ",")
europe_premiums_data <- read.csv("europe_preprocessed_premiums.csv", sep = ",")
north_america_premiums_data <- read.csv("north_america_preprocessed_premiums.csv", sep = ",")
oceania_premiums_data <- read.csv("oceania_preprocessed_premiums.csv", sep = ",")


# Getting imported climatic data into an understandable time series format for R
# Global temp and ohc
new_temp <- ts(data = clim_data$Value, start = 1993)
ohc <- ts(data = clim_data2$oceanHeatContent, start = 1993)

# Regional temp
asia_temp <- ts(data = asia_temp$Value, start = 1993)
europe_temp <- ts(data = europe_temp$Value, start = 1993)
north_america_temp <- ts(data = north_america_temp$Value, start = 1993)
oceania_temp <- ts(data = oceania_temp$Value, start = 1993)

# U.S. Climate Extremes Index (CEI)
# Contiguous U.S. Without Tropical Cyclone Indicator
cont_us_cei <- ts(data = cont_us_cei$Actual_Percent, start = 1993)


# Getting imported claims data into an understandable time series format for R
asia_claims_data <- ts(asia_claims_data$asia_wghtd_av, start = 1993)
europe_claims_data <- ts(europe_claims_data$europe_wghtd_av, start = 1993)
north_america_claims_data <- ts(north_america_claims_data$north_america_wghtd_av, start = 1993)
oceania_claims_data <- ts(oceania_claims_data$oceania_wghtd_av, start = 1993)

# Getting imported premiums data into an understandable time series format for R
asia_premiums_data <- ts(asia_premiums_data$asiaPrem_wghtd_av, start = 1993)
europe_premiums_data <- ts(europe_premiums_data$europePrem_wghtd_av, start = 1993)
north_america_premiums_data <- ts(north_america_premiums_data$north_americaPrem_wghtd_av, start = 1993)
oceania_premiums_data <- ts(oceania_premiums_data$oceaniaPrem_wghtd_av, start = 1993)

# DEALING WITH OUTLIERS
# visualizing outliers (climatic data)
par(mfrow=c(1,1))
par(mfrow=c(1,2))
outTemp <- boxplot.stats(new_temp)$out
boxplot(new_temp, ylab = "Global Temperature", main="After Winsorizing")
mtext(paste("Outliers: ", paste(outTemp, collapse = ", ")))

outOhc <- boxplot.stats(ohc)$out
boxplot(ohc, ylab = "Global Ocean Heat Content")
mtext(paste("Outliers: ", paste(outOhc, collapse = ", ")))

par(mfrow=c(2,2))
outTempA <- boxplot.stats(asia_temp)$out
boxplot(asia_temp, ylab = "Asia Temperature")
mtext(paste("Outliers: ", paste(outTempA, collapse = ", ")))

outTempE <- boxplot.stats(europe_temp)$out
boxplot(europe_temp, ylab = "Europe Temperature", main="After Winsorizing")
mtext(paste("Outliers: ", paste(outTempE, collapse = ", ")))

outTempNA <- boxplot.stats(north_america_temp)$out
boxplot(north_america_temp, ylab = "North America Temperature")
mtext(paste("Outliers: ", paste(outTempNA, collapse = ", ")))

outTempO <- boxplot.stats(oceania_temp)$out
boxplot(oceania_temp, ylab = "Oceania Temperature")
mtext(paste("Outliers: ", paste(outTempO, collapse = ", ")))

outUScei <- boxplot.stats(cont_us_cei)$out
boxplot(cont_us_cei, ylab = "Contiguous US CEI")
mtext(paste("Outliers: ", paste(outUScei, collapse = ", ")))


# visualizing outliers (claims)
par(mfrow=c(2,2))
outAsia <- boxplot.stats(asia_claims_data)$out
boxplot(asia_claims_data, ylab = "Asia claims")
mtext(paste("Outliers: ", paste(outAsia, collapse = ", ")))

outEurope <- boxplot.stats(europe_claims_data)$out
boxplot(europe_claims_data, ylab = "Europe claims")
mtext(paste("Outliers: ", paste(outEurope, collapse = ", ")))

outNA <- boxplot.stats(north_america_claims_data)$out
boxplot(north_america_claims_data, ylab = "North America claims", main="After Winsorizing")
mtext(paste("Outliers: ", paste(outNA, collapse = ", ")))

outOceania <- boxplot.stats(oceania_claims_data)$out
boxplot(oceania_claims_data, ylab = "Oceania claims")
mtext(paste("Outliers: ", paste(outOceania, collapse = ", ")))

# visualizing outliers (premiums)
par(mfrow=c(2,2))
outAsia <- boxplot.stats(asia_premiums_data)$out
boxplot(asia_premiums_data, ylab = "Asia premiums")
mtext(paste("Outliers: ", paste(outAsia, collapse = ", ")))

outEurope <- boxplot.stats(europe_premiums_data)$out
boxplot(europe_premiums_data, ylab = "Europe premiums")
mtext(paste("Outliers: ", paste(outEurope, collapse = ", ")))

outNA <- boxplot.stats(north_america_premiums_data)$out
boxplot(north_america_premiums_data, ylab = "North America premiums")
mtext(paste("Outliers: ", paste(outNA, collapse = ", ")))

outOceania <- boxplot.stats(oceania_premiums_data)$out
boxplot(oceania_premiums_data, ylab = "Oceania premiums")
mtext(paste("Outliers: ", paste(outOceania, collapse = ", ")))

# treating outliers
# winsorizing method
# calculating bench mark value
# formula: Q3(data) + 1.5*IQR(data)

#=== climatic data
summary(new_temp)
benchNA <- 0.7050  + (1.5*IQR(new_temp)) # formula: Q3(data) + 1.5*IQR(data)
new_temp[new_temp>benchNA]
new_temp[new_temp>benchNA] <- benchNA

summary(europe_temp)
benchNA <- 0.775 - (1.5*IQR(europe_temp)) # formula: Q1(data) - 1.5*IQR(data)
europe_temp[europe_temp<benchNA]
europe_temp[europe_temp<benchNA] <- benchNA

#=== insurance data
summary(north_america_claims_data)
benchNA <- 0.8958 + (1.5*IQR(north_america_claims_data)) # formula: Q3(data) + 1.5*IQR(data)
north_america_claims_data[north_america_claims_data>benchNA]
north_america_claims_data[north_america_claims_data>benchNA] <- benchNA

#=== no detected outliers for premiums

# Data Visualization of Time series 
# Temp, Claims, Premiums
# Visualizing the temperature trend from 1993 to 2019
par(mfrow=c(1,1))  
par(mfrow=c(1,2))                              # divide chart window into sections
#plot(clim_data$Value~clim_data$Year)          # use this code to plot when data is not in the time series format for R
plot(new_temp, ylab = "Anomaly (degree celcius)", main = "Global Land-Ocean Annual Temperature Anomalies")
plot(ohc, ylab = "Anomaly (10^12 Joules)", main = "Global Ocean Heat Content Anomalies (0-700m)")

# regional temp time series plots
par(mfrow=c(2,2))                             # divide chart window into sections
plot(asia_temp, ylab = "Anomaly (degree celcius)", main = "Asia Land Annual Temerature Anomalies")
plot(europe_temp, ylab = "Anomaly (degree celcius)", main = "Europe Land Annual Temerature Anomalies")
plot(north_america_temp, ylab = "Anomaly (degree celcius)", main = "North America Land Annual Temerature Anomalies")
plot(oceania_temp, ylab = "Anomaly (degree celcius)", main = "Oceania Land Annual Temerature Anomalies")

par(mfrow=c(1,1))
# Contiguous U.S. CEI
plot(cont_us_cei, ylab = "Actual Percent", main = "Contiguous U.S. Climate Extreme Index")


par(mfrow=c(2,2))                             # divide chart window into sections
plot(asia_claims_data, ylab = "Weighted Average", main = "Asia Insurance Claims")
plot(europe_claims_data, ylab = "Weighted Average", main = "Europe Insurance Claims")
plot(north_america_claims_data, ylab = "Weighted Average", main = "North America Insurance Claims")
plot(oceania_claims_data, ylab = "Weighted Average", main = "Oceania Insurance Claims")

par(mfrow=c(2,2))                             # divide chart window into sections
plot(asia_premiums_data, ylab = "Weighted Average", main = "Asia Insurance Premiums")
plot(europe_premiums_data, ylab = "Weighted Average", main = "Europe Insurance Premiums")
plot(north_america_premiums_data, ylab = "Weighted Average", main = "North America Insurance Premiums")
plot(oceania_premiums_data, ylab = "Weighted Average", main = "Oceania Insurance Premiums")


# AUTOREGRESSION & CROSS CORRELATION


# Global climatic (temp & ohc) data
par(mfrow=c(1,1))
acf(new_temp, main="Series: Global Temperature"); acf(diff(new_temp), main="Series: Differenced Global Temperature")
acf(ohc, main="Series: Global Ocean Heat Content"); acf(diff(ohc), main="Series: Differenced Global Ocean Heat Content")

# Regional temp data
par(mfrow=c(2,2))
acf(asia_temp, main="Series: Asia Temperature"); acf(diff(asia_temp), main="Series: Differenced Asia Temperature")
acf(europe_temp); acf(diff(europe_temp))

par(mfrow=c(2,2))
acf(north_america_temp); acf(diff(north_america_temp))
acf(oceania_temp); acf(diff(oceania_temp))

# Contiguous U.S. CEI
acf(cont_us_cei, main="Series: Contiguous U.S. Climate Extreme Index"); acf(diff(cont_us_cei), main="Series: Differenced Contiguous U.S. Climate Extreme Index")

# Regional claims
par(mfrow=c(2,2))
acf(asia_claims_data); acf(diff(asia_claims_data))
acf(europe_claims_data); acf(diff(europe_claims_data))

par(mfrow=c(2,2))
acf(north_america_claims_data, main="Series: North America Insurance Claims"); acf(diff(north_america_claims_data), main="Series: Differenced North America Insurance Claims")
acf(oceania_claims_data, main="Series: Oceania Insurance Claims"); acf(diff(oceania_claims_data), main="Series: Differenced Oceania Insurance Claims")

# Regional premiums
par(mfrow=c(2,2))
acf(asia_premiums_data); acf(diff(asia_premiums_data))
acf(europe_premiums_data, main="Series: Europe Insurance Premiums"); acf(diff(europe_premiums_data), main="Series: Differenced Europe Insurance Premiums")

par(mfrow=c(2,2))
acf(north_america_premiums_data); acf((diff(diff(log(north_america_premiums_data)))))
acf(oceania_premiums_data, main="Series: Oceania Insurance Premiums"); acf((diff(diff(diff(log(oceania_premiums_data))))), main="Series: Differenced Oceania Insurance Premiums")

# confirming the stationarity of time series before first differencing
# climatic data
# global
adf.test((new_temp))
adf.test((ohc))

# regional
adf.test((asia_temp))
adf.test((europe_temp))
adf.test((north_america_temp))
adf.test((oceania_temp))

# contiguous U.S. CEI
adf.test((cont_us_cei))

# financial data
# claims data
adf.test((asia_claims_data))
adf.test((europe_claims_data))
adf.test((north_america_claims_data))
adf.test((oceania_claims_data))

# premiums data
adf.test((asia_premiums_data))
adf.test((europe_premiums_data))
adf.test((north_america_premiums_data))
adf.test((oceania_premiums_data))

# box-jenkins again to test stationarity on differenced time series
# climatic data
# global
adf.test(diff(new_temp))
adf.test(diff(ohc))

# regional
adf.test(diff(asia_temp))
adf.test(diff(europe_temp))
adf.test((north_america_temp))
adf.test(diff(oceania_temp))

# contiguous U.S. CEI
adf.test(diff(cont_us_cei))

# financial data
# claims data
adf.test(diff(diff(asia_claims_data)))
adf.test(diff(diff(europe_claims_data)))
adf.test((diff(north_america_claims_data)))
adf.test(diff(diff(oceania_claims_data)))

# premiums data
adf.test(diff(diff(asia_premiums_data)))
adf.test(diff(diff(europe_premiums_data)))
adf.test(diff(diff(log(north_america_premiums_data))))
adf.test(diff(diff(diff(log(oceania_premiums_data)))))

# saving differenced time series into variables
global_temp <- (diff(new_temp))
global_ohc <- (diff(ohc))

# regional
Asia_Temp <- (diff(asia_temp))
Europe_Temp <- (diff(europe_temp))
# this space is empty, because north_america_temp needs not to be detrended
Oceania_Temp <- (diff(oceania_temp))

# contiguous U.S. CEI
Cont_US_CEI <- (diff(cont_us_cei))

# financial data
# claims data
asia_claims <- (diff(diff(asia_claims_data)))
europe_claims <- (diff(diff(europe_claims_data)))
north_america_claims <- ((diff(north_america_claims_data)))
oceania_claims <- (diff(diff(oceania_claims_data)))

# premiums data
asia_premiums <- (diff(diff(asia_premiums_data)))
europe_premiums <- (diff(diff(europe_premiums_data)))
north_america_premiums <- (diff(diff(log(north_america_premiums_data))))
oceania_premiums <- (diff(diff(diff(log(oceania_premiums_data)))))

# cross-correlation plots
# claims
# global temp vs. regional claims 
par(mfrow=c(2,2))
ccf(global_temp, asia_claims)
ccf(global_temp, europe_claims)
ccf(global_temp, north_america_claims)
ccf(global_temp, oceania_claims, main="Global Temperature & Oceania Insurance Claims")

# regional temp vs. regional claims
par(mfrow=c(1,1))
ccf(Asia_Temp, asia_claims, main="asia_temp & asia_claims")
ccf(Europe_Temp, europe_claims, main="Europe Temperature & Europe Insurance Claims")
ccf(north_america_temp, north_america_claims)
ccf(Oceania_Temp, oceania_claims, main="Oceania Temperature & Oceania Insurance Claims")

# contiguous U.S. CEI
ccf(Cont_US_CEI, north_america_claims, main="Contiguous U.S. Climate Extreme Index & North America Insurance Claims")

# global ohc vs. regional claims
par(mfrow=c(2,2))
ccf(global_ohc, asia_claims, main="Global Ocean Heat Content & Asia Insurance Claims")
ccf(global_ohc, europe_claims, )
ccf(global_ohc, north_america_claims, main="Global Ocean Heat Content & North America Insurance Claims")
ccf(global_ohc, oceania_claims, main="Global Ocean Heat Content & Oceania Insurance Claims")

# premiums
# global temp vs. regional premiums 
par(mfrow=c(2,2))
ccf(global_temp, asia_premiums, main="Global Temperature & Asia Insurance Premiums")
ccf(global_temp, europe_premiums, main="Global Temperature & Europe Insurance Premiums")
ccf(global_temp, north_america_premiums)
ccf(global_temp, oceania_premiums, main="Global Temperature & Oceania Insurance Premiums")

# regional temp vs. regional premiums
par(mfrow=c(2,2))
ccf(Asia_Temp, asia_premiums, main="asia_temp & asia_premiums")
ccf(Europe_Temp, europe_premiums, main="europe_temp & europe_premiums")
ccf(north_america_temp, north_america_premiums)
ccf(Oceania_Temp, oceania_premiums, main="oceania_temp & oceania_premiums")

# contiguous U.S. CEI
ccf(Cont_US_CEI, north_america_premiums, main="Contiguous U.S. Climate Extreme Index & North America Premiums")

# global ohc vs. regional premiums
par(mfrow=c(2,2))
ccf(global_ohc, asia_premiums, main="Global Ocean Heat Content & Asia Insurance Premiums")
ccf(global_ohc, europe_premiums, main="Global Ocean Heat Content & Europe Insurance Premiums")
ccf(global_ohc, north_america_premiums, main="Global Ocean Heat Content & North America Insurance Premiums")
ccf(global_ohc, oceania_premiums)


# GRANGER'S COINTEGRATION TEST
# two-step approach
# claims
# step 1
# run regression with trend
gt_ac_reg <- lm(new_temp~asia_claims_data)
gt_ec_reg <- lm(new_temp~europe_claims_data)
gt_NAc_reg <- lm(new_temp~north_america_claims_data)
gt_oc_reg <- lm(new_temp~oceania_claims_data)

at_ac_reg <- lm(asia_temp~asia_claims_data)
et_ec_reg <- lm(europe_temp~europe_claims_data)
NAt_NAc_reg <- lm(north_america_temp~north_america_claims_data)
ot_oc_reg <- lm(oceania_temp~oceania_claims_data)

CusCei_NAc_reg <- lm(cont_us_cei~north_america_claims_data)

gOHC_ac_reg <- lm(ohc~asia_claims_data)
gOHC_ec_reg <- lm(ohc~europe_claims_data)
gOHC_NAc_reg <- lm(ohc~north_america_claims_data)
gOHC_oc_reg <- lm(ohc~oceania_claims_data)

# premiums
gt_ap_reg <- lm(new_temp~asia_premiums_data)
gt_ep_reg <- lm(new_temp~europe_premiums_data)
gt_NAp_reg <- lm(new_temp~north_america_premiums_data)
gt_op_reg <- lm(new_temp~oceania_premiums_data)

at_ap_reg <- lm(asia_temp~asia_premiums_data)
et_ep_reg <- lm(europe_temp~europe_premiums_data)
NAt_NAp_reg <- lm(north_america_temp~north_america_premiums_data)
ot_op_reg <- lm(oceania_temp~oceania_premiums_data)

CusCei_NAp_reg <- lm(cont_us_cei~north_america_premiums_data)

gOHC_ap_reg <- lm(ohc~asia_premiums_data)
gOHC_ep_reg <- lm(ohc~europe_premiums_data)
gOHC_NAp_reg <- lm(ohc~north_america_premiums_data)
gOHC_op_reg <- lm(ohc~oceania_premiums_data)


# claims
# step 1b
# store residuals
resid_gt_ac_reg <- gt_ac_reg$residuals
resid_gt_ec_reg <- gt_ec_reg$residuals
resid_gt_NAc_reg <- gt_NAc_reg$residuals
resid_gt_oc_reg <- gt_oc_reg$residuals

resid_at_ac_reg <- at_ac_reg$residuals
resid_et_ec_reg <- et_ec_reg$residuals
resid_NAt_NAc_reg <- NAt_NAc_reg$residuals
resid_ot_oc_reg <- ot_oc_reg$residuals

resid_CusCei_NAc_reg <- CusCei_NAc_reg$residuals

resid_gOHC_ac_reg <- gOHC_ac_reg$residuals
resid_gOHC_ec_reg <- gOHC_ec_reg$residuals
resid_gOHC_NAc_reg <- gOHC_NAc_reg$residuals
resid_gOHC_oc_reg <- gOHC_oc_reg$residuals


# premiums
resid_gt_ap_reg <- gt_ap_reg$residuals
resid_gt_ep_reg <- gt_ep_reg$residuals
resid_gt_NAp_reg <- gt_NAp_reg$residuals
resid_gt_op_reg <- gt_op_reg$residuals

resid_at_ap_reg <- at_ap_reg$residuals
resid_et_ep_reg <- et_ep_reg$residuals
resid_NAt_NAp_reg <- NAt_NAp_reg$residuals
resid_ot_op_reg <- ot_op_reg$residuals

resid_CusCei_NAp_reg <- CusCei_NAp_reg$residuals

resid_gOHC_ap_reg <- gOHC_ap_reg$residuals
resid_gOHC_ep_reg <- gOHC_ep_reg$residuals
resid_gOHC_NAp_reg <- gOHC_NAp_reg$residuals
resid_gOHC_op_reg <- gOHC_op_reg$residuals
# ensure that both variables are non-stationary
# and integrated of same order such as I(1) or I(2)


# step 2
# conduct stationarity/unit root test on stored residuals
# test statistic
# claims
gt_ac <- ur.df(resid_gt_ac_reg, type="none", selectlags="AIC")
gt_ec <- ur.df(resid_gt_ec_reg, type="none", selectlags="AIC")
gt_NAc <- ur.df(resid_gt_NAc_reg, type="none", selectlags="AIC")
gt_oc <- ur.df(resid_gt_oc_reg, type="none", selectlags="AIC")

at_ac <- ur.df(resid_at_ac_reg, type="none", selectlags="AIC")
et_ec <- ur.df(resid_et_ec_reg, type="none", selectlags="AIC")
NAt_NAc <- ur.df(resid_NAt_NAc_reg, type="none", selectlags="AIC")
ot_oc <- ur.df(resid_ot_oc_reg, type="none", selectlags="AIC")

ccei_NAc <- ur.df(resid_CusCei_NAc_reg, type="none", selectlags="AIC")

gOHC_ac <- ur.df(resid_gOHC_ac_reg, type="none", selectlags="AIC")
gOHC_ec <- ur.df(resid_gOHC_ec_reg, type="none", selectlags="AIC")
gOHC_NAc <- ur.df(resid_gOHC_NAc_reg, type="none", selectlags="AIC")
gOHC_oc <- ur.df(resid_gOHC_oc_reg, type="none", selectlags="AIC")


# premiums
gt_ap <- ur.df(resid_gt_ap_reg, type="none", selectlags="AIC")
gt_ep <- ur.df(resid_gt_ep_reg, type="none", selectlags="AIC")
gt_NAp <- ur.df(resid_gt_NAp_reg, type="none", selectlags="AIC")
gt_op <- ur.df(resid_gt_op_reg, type="none", selectlags="AIC")

at_ap <- ur.df(resid_at_ap_reg, type="none", selectlags="AIC")
et_ep <- ur.df(resid_et_ep_reg, type="none", selectlags="AIC")
NAt_NAp <- ur.df(resid_NAt_NAp_reg, type="none", selectlags="AIC")
ot_op <- ur.df(resid_ot_op_reg, type="none", selectlags="AIC")

ccei_NAp <- ur.df(resid_CusCei_NAp_reg, type="none", selectlags="AIC")

gOHC_ap <- ur.df(resid_gOHC_ap_reg, type="none", selectlags="AIC")
gOHC_ep <- ur.df(resid_gOHC_ep_reg, type="none", selectlags="AIC")
gOHC_NAp <- ur.df(resid_gOHC_NAp_reg, type="none", selectlags="AIC")
gOHC_op <- ur.df(resid_gOHC_op_reg, type="none", selectlags="AIC")

?ur.df

# summary
# claims
summary(gt_ac)
summary(gt_ec)
summary(gt_NAc)
summary(gt_oc)

summary(at_ac)
summary(et_ec)
summary(NAt_NAc)
summary(ot_oc)

summary(ccei_NAc)

summary(gOHC_ac)
summary(gOHC_ec)
summary(gOHC_NAc)
summary(gOHC_oc)

# premiums
summary(gt_ap)
summary(gt_ep)
summary(gt_NAp)
summary(gt_op)

summary(at_ap)
summary(et_ep)
summary(NAt_NAp)
summary(ot_op)

summary(ccei_NAp)

summary(gOHC_ap)
summary(gOHC_ep)
summary(gOHC_NAp)
summary(gOHC_op)

# extract the main statistic estimates you need
# claims
gt_ac@teststat ;gt_ac@cval
gt_ec@teststat ;gt_ec@cval
gt_NAc@teststat ;gt_NAc@cval
gt_oc@teststat ;gt_oc@cval

at_ac@teststat ;at_ac@cval
et_ec@teststat ;et_ec@cval
NAt_NAc@teststat ;NAt_NAc@cval
ot_oc@teststat ;ot_oc@cval

ccei_NAc@teststat ;ccei_NAc@cval


gOHC_ac@teststat ;gOHC_ac@cval
gOHC_ec@teststat ;gOHC_ec@cval
gOHC_NAc@teststat ;gOHC_NAc@cval
gOHC_oc@teststat ;gOHC_oc@cval

# premiums
gt_ap@teststat ;gt_ap@cval
gt_ep@teststat ;gt_ep@cval
gt_NAp@teststat ;gt_NAp@cval
gt_op@teststat ;gt_op@cval

at_ap@teststat ;at_ap@cval
et_ep@teststat ;et_ep@cval
NAt_NAp@teststat ;NAt_NAp@cval
ot_op@teststat ;ot_op@cval

ccei_NAp@teststat ;ccei_NAp@cval

gOHC_ap@teststat ;gOHC_ap@cval
gOHC_ep@teststat ;gOHC_ep@cval
gOHC_NAp@teststat ;gOHC_NAp@cval
gOHC_op@teststat ;gOHC_op@cval


# GRANGER'S CAUSALITY TEST
# for causality test, series must be STATIONARY
# claims
# global temp vs. regional claims 
gt_AC <- cbind(global_temp, asia_claims); gt_AC <- na.omit(gt_AC)
gt_EC <- cbind(global_temp, europe_claims); gt_EC <- na.omit(gt_EC)
gt_NAC <- cbind(global_temp, north_america_claims); gt_NAC <- na.omit(gt_NAC) 
gt_OC <- cbind(global_temp, oceania_claims); gt_OC <- na.omit(gt_OC)

# regional temp vs. regional claims
at_AC <- cbind(Asia_Temp, asia_claims); at_AC <- na.omit(at_AC)
et_EC <- cbind(Europe_Temp, europe_claims); et_EC <- na.omit(et_EC)
NAt_NAC <- cbind(north_america_temp, north_america_claims); NAt_NAC <- na.omit(NAt_NAC)
ot_OC <- cbind(Oceania_Temp, oceania_claims); ot_OC <- na.omit(ot_OC)

# contiguous U.S. CEI vs. north america claims
Ccei_NAC <- cbind(Cont_US_CEI, north_america_claims); NAt_NAC <- na.omit(Ccei_NAC)

# global ohc vs. regional claims
gOHC_AC <- cbind(global_ohc, asia_claims); gOHC_AC <- na.omit(gOHC_AC)
gOHC_EC <- cbind(global_ohc, europe_claims); gOHC_EC <- na.omit(gOHC_EC)
gOHC_NAC <- cbind(global_ohc, north_america_claims); gOHC_NAC <- na.omit(gOHC_NAC)
gOHC_OC <- cbind(global_ohc, oceania_claims); gOHC_OC <- na.omit(gOHC_OC)

# premiums
# global temp vs. regional premiums 
gt_AP <- cbind(global_temp, asia_premiums); gt_AP <- na.omit(gt_AP)
gt_EP <- cbind(global_temp, europe_premiums); gt_EP <- na.omit(gt_EP)
gt_NAP <- cbind(global_temp, north_america_premiums); gt_NAP <- na.omit(gt_NAP)
gt_OP <- cbind(global_temp, oceania_premiums); gt_OP <- na.omit(gt_OP)

# regional temp vs. regional premiums
at_AP <- cbind(Asia_Temp, asia_premiums); at_AP <- na.omit(at_AP)
et_EP <- cbind(Europe_Temp, europe_premiums); et_EP <- na.omit(et_EP)
NAt_NAP <- cbind(north_america_temp, north_america_premiums); NAt_NAP <- na.omit(NAt_NAP)
ot_OP <- cbind(Oceania_Temp, oceania_premiums); ot_OP <- na.omit(ot_OP)

# contiguous U.S. CEI vs. north america premiums
Ccei_NAP <- cbind(Cont_US_CEI, north_america_premiums); Ccei_NAP <- na.omit(Ccei_NAP)

# global ohc vs. regional premiums
gOHC_AP <- cbind(global_ohc, asia_premiums); gOHC_AP <- na.omit(gOHC_AP)
gOHC_EP <- cbind(global_ohc, europe_premiums); gOHC_EP <- na.omit(gOHC_EP)
gOHC_NAP <- cbind(global_ohc, north_america_premiums); gOHC_NAP <- na.omit(gOHC_NAP)
gOHC_OP <- cbind(global_ohc, oceania_premiums); gOHC_OP <- na.omit(gOHC_OP)


# two series to be tested for granger causality test
# fitting a VAR model
# since Granger causality is sensitive to lag length
# we let the model decide optimal lag length as per AIC
# claims
# global temp vs. regional claims 
gt_AC_VAR <- VAR(gt_AC, type="const", ic="AIC")     #  lag.max=15, could be useful for lag restriction
gt_EC_VAR <- VAR(gt_EC, type="const", ic="AIC")
gt_NAC_VAR <- VAR(gt_NAC, type="const", ic="AIC")
gt_OC_VAR <- VAR(gt_OC, type="const", ic="AIC")

# regional temp vs. regional claims
at_AC_VAR <- VAR(at_AC, type="const", ic="AIC")
et_EC_VAR <- VAR(et_EC, type="const", ic="AIC")
NAt_NAC_VAR <- VAR(NAt_NAC, type="const", ic="AIC")
ot_OC_VAR <- VAR(ot_OC, type="const", ic="AIC")

# contiguous U.S. CEI vs. north america claims
Ccei_NAC_VAR <- VAR(Ccei_NAC, type="const", ic="AIC")

# global ohc vs. regional claims
gOHC_AC_VAR <- VAR(gOHC_AC, type="const", ic="AIC")
gOHC_EC_VAR <- VAR(gOHC_EC, type="const", ic="AIC")
gOHC_NAC_VAR <- VAR(gOHC_NAC, type="const", ic="AIC")
gOHC_OC_VAR <- VAR(gOHC_OC, type="const", ic="AIC")

# premiums
# global temp vs. regional premiums 
gt_AP_VAR <- VAR(gt_AP, type="const", ic="AIC")
gt_EP_VAR <- VAR(gt_EP, type="const", ic="AIC")
gt_NAP_VAR <- VAR(gt_NAP, type="const", ic="AIC")
gt_OP_VAR <- VAR(gt_OP, type="const", ic="AIC")

# regional temp vs. regional premiums
at_AP_VAR <- VAR(at_AP, type="const", ic="AIC")
et_EP_VAR <- VAR(et_EP, type="const", ic="AIC")
NAt_NAP_VAR <- VAR(NAt_NAP, type="const", ic="AIC")
ot_OP_VAR <- VAR(ot_OP, type="const", ic="AIC")

# contiguous U.S. CEI vs. north america claims
Ccei_NAP_VAR <- VAR(Ccei_NAP, type="const", ic="AIC"); 


# global ohc vs. regional premiums
gOHC_AP_VAR <- VAR(gOHC_AP, type="const", ic="AIC")
gOHC_EP_VAR <- VAR(gOHC_EP, type="const", ic="AIC")
gOHC_NAP_VAR <- VAR(gOHC_NAP, type="const", ic="AIC")
gOHC_OP_VAR <- VAR(gOHC_OP, type="const", ic="AIC")


# now test for granger causality
# Null: claims does not cause temp, then
# claims would be independent variable
# temp would be dependent variable

# claims
causality(gt_AC_VAR, cause="global_temp")$Granger
causality(gt_EC_VAR, cause="global_temp")$Granger
causality(gt_NAC_VAR, cause="global_temp")$Granger
causality(gt_OC_VAR, cause="global_temp")$Granger

causality(at_AC_VAR, cause="Asia_Temp")$Granger
causality(et_EC_VAR, cause="Europe_Temp")$Granger
causality(NAt_NAC_VAR, cause="north_america_temp")$Granger
causality(ot_OC_VAR, cause="Oceania_Temp")$Granger

causality(Ccei_NAC_VAR, cause="Cont_US_CEI")$Granger

causality(gOHC_AC_VAR, cause="global_ohc")$Granger
causality(gOHC_EC_VAR, cause="global_ohc")$Granger
causality(gOHC_NAC_VAR, cause="global_ohc")$Granger
causality(gOHC_OC_VAR, cause="global_ohc")$Granger

# premiums
causality(gt_AP_VAR, cause="global_temp")$Granger
causality(gt_EP_VAR, cause="global_temp")$Granger
causality(gt_NAP_VAR, cause="global_temp")$Granger
causality(gt_OP_VAR, cause="global_temp")$Granger

causality(at_AP_VAR, cause="Asia_Temp")$Granger
causality(et_EP_VAR, cause="Europe_Temp")$Granger
causality(NAt_NAP_VAR, cause="north_america_temp")$Granger
causality(ot_OP_VAR, cause="Oceania_Temp")$Granger

causality(Ccei_NAP_VAR, cause="Cont_US_CEI")$Granger

causality(gOHC_AP_VAR, cause="global_ohc")$Granger
causality(gOHC_EP_VAR, cause="global_ohc")$Granger
causality(gOHC_NAP_VAR, cause="global_ohc")$Granger
causality(gOHC_OP_VAR, cause="global_ohc")$Granger
