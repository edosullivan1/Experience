# -*- coding: utf-8 -*-
"""
Created on Thu Jan 27 14:16:00 2022

@author: edosc
"""


import os, json
import pandas as pd

# this finds our json files
path_to_json = r'C:\Users\edosc\OneDrive - TCDUD.onmicrosoft.com\Desktop\openpose\output'
json_files = [pos_json for pos_json in os.listdir(path_to_json) if pos_json.endswith('.json')]

# here I define my pandas Dataframe with the columns I want to get from the json
jsons_data = pd.DataFrame(columns=['1']) #'2', '3','4', '5', '6','7', '8', '9','10', '11', '12'])

# we need both the json and an index number so use enumerate()
for index, js in enumerate(json_files):
    with open(os.path.join(path_to_json, js)) as json_file:
        json_text = json.load(json_file)

        # here you need to know the layout of your json and each json has to have
        # the same structure (obviously not the structure I have here)
        position = json_text['people'][0]['pose_keypoints_2d']
        
        # here I push a list of data into a pandas DataFrame at row given by 'index'
        jsons_data.loc[index] = [position]

#jsons_data.to_csv('C:\\Users\\edosc\\OneDrive - TCDUD.onmicrosoft.com\\MAI\\Project\\OpenPose\\+ciaran_2D_position.csv')

