# -*- coding: utf-8 -*-
"""
Aggregate course structure json data into a dataframe

Created on Mon Jul 11 21:37:00 2016

@author: Ziwei
"""

import json
import re
import pandas as pd

workpath = 'clean_data\\'

def find_category(s):
    return re.findall(r"[\w']+", s)[-3]
    
def find_parent(df,s):
    return df[df['child']==s]['parent'].tolist()[0]

def get_structure_dataframe(workpath):
    cs = json.load(open(workpath+'ColumbiaX-DS101X-1T2016-course_structure-prod-analytics.json'))
    nodes = cs.keys()

    map = []
    for node in nodes:
        child_list = cs[node]['children']
        pairs = [(node,find_category(node),child,find_category(child)) for child in child_list]
        #it eliminates all the null child
        map.extend(pairs)
    
    cs_map_df = pd.DataFrame(map)
    cs_map_df.columns = ['parent','parent_type','child','child_type']

    terms = list(cs_map_df[cs_map_df['child_type'].isin(['html','video','problem','discussion'])]['child'])
    verts = [find_parent(cs_map_df,t) for t in terms]
    seqs = [find_parent(cs_map_df,v) for v in verts]
    chaps = [find_parent(cs_map_df,s) for s in seqs]
    cous = [find_parent(cs_map_df,c) for c in chaps]

    structure_df = pd.DataFrame(zip(cous,chaps,seqs,verts,terms))
    structure_df.columns = ['course','chapter','sequential','vertical','terminal']
    
    return structure_df
    
if __name__=='__main__':
    df = get_structure_dataframe(workpath)
    df.to_csv(workpath+'course_structure.csv')










