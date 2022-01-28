# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import pandas as pd
import datetime as dt
import numpy as np
from pandas import DataFrame
from datetime import date, datetime, timedelta
import sys
import timeit
import calendar

#Read-in Generation and Availability

df_GenAva = pd.read_excel (r"C:\Users\edosc\Documents\Internship\Forecast_Script\GEN_AVA_APR_APR_CURRENT_IE_NI.xlsx")
  
#Read in part 1 and part 2 of Forecast data
#Read-in test data

df_PartOneForecast = pd.read_excel (r"C:\Users\edosc\Documents\Internship\Forecast_Script\WEF_APR_APR.xlsx")

df_PartTwoForecast = pd.read_excel (r"C:\Users\edosc\Documents\Internship\Forecast_Script\WEF_APR_APR_Part_Two.xlsx")

#df_TestForecast = pd.read_excel (r"C:\Users\edosc\Documents\Internship\Forecast_Script\WEF_APR_APR_TEST.xlsx")
#df_CombinedForecast = df_TestForecast
#Create new dataset
#Combine part 1 and part 2 forecast using .concat

df_list = [df_PartOneForecast, df_PartTwoForecast]
df_CombinedForecast = pd.concat(df_list)


#Change Forecast and Timepoint from object to datetime
#Change Date and time in df_GenAva from object to datetime 

df_CombinedForecast['Forecast'] = pd.to_datetime(df_CombinedForecast.Forecast)    
df_CombinedForecast['Timepoint'] = pd.to_datetime(df_CombinedForecast.Timepoint)    
df_GenAva['Date and Time'] = pd.to_datetime(df_GenAva['Date and Time']) 

#Rename Column in GenAva dataframe from Date and Time to Timepoint to match forecast dataframe

df_GenAva = df_GenAva.rename(columns = {'Date and Time' : 'Timepoint'})
df_CombinedForecast = df_CombinedForecast.rename(columns = {'MW' : 'Forecast_MW'})
#Filter dataset for ROI only
df_CombinedForecast = df_CombinedForecast.loc[df_CombinedForecast["Region"] == ("ROI")]

#Reset index
df_CombinedForecast = df_CombinedForecast.reset_index()

#Create delta_t column
df_CombinedForecast['delta_t'] = df_CombinedForecast['Timepoint'] - df_CombinedForecast['Forecast']

#Range 3-9 hours filtering
min_delta_t = dt.timedelta(hours = 2.75)
max_delta_t = dt.timedelta(hours = 9.25)

df_CombinedForecast = df_CombinedForecast.loc[df_CombinedForecast['delta_t'] > min_delta_t]

df_CombinedForecast = df_CombinedForecast.loc[df_CombinedForecast['delta_t'] < max_delta_t]

#Create column in master dataframe for Generation IE dataframe and match it each value to the correct date
df_GenAva.drop(['Availability IE', 'Generated NI', 'Availability NI'], axis = 1, inplace = True)

df_masterIE = pd.merge(df_CombinedForecast, df_GenAva)

#Filter forecast below 500 MW
df_masterIE = df_masterIE[df_masterIE.Forecast_MW <= 500]

#Define Vendor 1 and 2 dataframes
df_masterIE_V1 = df_masterIE
df_masterIE_V2 = df_masterIE

#Filter Vendor 1 into new dataframe


Vendor_1 = 1
Vendor_3 = 3
df_masterIE_V1 = df_masterIE_V1[df_masterIE_V1.Vendor == Vendor_1].reset_index()

df_masterIE_V2 = df_masterIE_V2[df_masterIE_V2.Vendor == Vendor_3].reset_index()



#Metrics: Forecast Error, Bias
#Forecast Error = Actual Generation - Forecast
#Squared Error = Error ^2
#Mean Squared Error = Average of squared error
#Bias = number of times forecasted above or below generation
df_masterIE_V1['Forecast Error'] = df_masterIE_V1['Forecast_MW'] - df_masterIE_V1['Generation IE'] 
df_masterIE_V1['Squared Error'] = df_masterIE_V1['Forecast Error']**2


#Print out Mean Error
mean_error_V1 = df_masterIE_V1['Forecast Error'].mean()
print('The mean error for Vendor 1 is', mean_error_V1)

#Print out Mean Squared Error
mean_squared_error_V1 = df_masterIE_V1['Squared Error'].mean()
print('The mean squared error for Vendor 1 is', mean_squared_error_V1)





#Vendor 2
df_masterIE_V2['Forecast Error'] = df_masterIE_V2['Forecast_MW'] - df_masterIE_V2['Generation IE'] 
df_masterIE_V2['Squared Error'] = df_masterIE_V2['Forecast Error']**2


#Print out Mean Error
mean_error_V2 = df_masterIE_V2['Forecast Error'].mean()
print('The mean error for Vendor 2 is', mean_error_V2)

#Print out Mean Squared Error
mean_squared_error_V2 = df_masterIE_V2['Squared Error'].mean()
print('The mean squared error for Vendor 2 is', mean_squared_error_V2)



'''
indexes_to_drop = []

#i = len(df_CombinedForecast)
for i in df_CombinedForecast.index:
    
    if df_CombinedForecast.delta_t(i) < min_delta_t:
        indexes_to_drop.append(i)
        continue
   
    if df_CombinedForecast.delta_t(i) > max_delta_t:
        indexes_to_drop.append(i)
        continue
    i+=1

df_CombinedForecast = df_CombinedForecast.drop(df_CombinedForecast.index[indexes_to_drop], inplace=True )
'''
#Reset Index


'''
df_CombinedForecast = df_CombinedForecast[(df_CombinedForecast['Region'].str.contains("ROI"))]

#
Code sample for Forecast minus Timepoint

indexes_to_drop = []

for i in df.index:
    ....
    if {make your decision here}:
        indexes_to_drop.append(i)
    ....

df.drop(df.index[indexes_to_drop], inplace=True )
#
'''

'''
#OLD IF statement to filter forecasts from 3 to 9 hours out into new dataset


i = 0

while i < len(delta_t):

    if delta_t[i] >= min_delta_t and  delta_t[i] <= max_delta_t:
        six_hours_out = df_CombinedForecast_ROI.loc[i]
        i += 1
    else: 
        i += 1
            
six_hours_out = [0]

#df_CombinedForecast_ROI_Vendor_ONE = df_CombinedForecast_ROI[df_CombinedForecast['Vendor'] == 3]

'''

#Filter dataset for Vendor 1
#df_CombinedForecast_ROI_Vendor_1 = df_CombinedForecast[df_CombinedForecast['Region'].str.contains("ROI")]
#df_CombinedForecast_ROI_Vendor_2 = df_CombinedForecast[df_CombinedForecast['Region'].str.contains("ROI")]

#column.delete['']

#df_PartOneForecast.info()

#if (OneDayForecast['Forecast Time'] - OneDayForecast['TimePoint'] >= 3) and (OneDayForecast['Forecast Time'] - OneDayForecast['TimePoint'] <= 9):
    #store line