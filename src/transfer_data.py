#clean_first
#-*-coding: utf8 -*-
import pandas as pd
import os
import cPickle as pickle
import json
import tarfile

raw_dir = "Columbiax-2016-06-12\\"
#make sure current directory is the parent directory of Columbiax-2016-06-12
clean_dir = "Columbiax-2016-06-12\\py_data\\course_1\\"

ind_folders = os.listdir(raw_dir)
#all folders under Columbiax-2016-06-12



##################################
# explore contents of course one #
##################################
attrs = [ind_folders[d] for d in range(17) ]
attrs = sorted(attrs, key=lambda x: x[-1])
#sort files by type, now attrs[0:14] are .sql, attrs[14] is .json, attrs[15] is .mongo, attrs[16] is .xml.tar.gz

#in order to easily do further analysis, I transfer .sql and .mongo to python dataframe, leave json as original and unzip .tar.gz to xml.
def transfer_sql():
    ind = 0
    for each in attrs[0:14]:
        dict = {}
        n = 0 
        with open(raw_dir+attrs[ind]) as f:
            for eachline in f:
                eachline = eachline.strip().split('\t')
                dict[n]=eachline
                n+=1
        df = pd.DataFrame.from_dict(dict,'index')
        new_header = df.iloc[0]
        df = df[1:]
        df.columns=new_header
        name = attrs[ind].split('.')[0]
        with open(clean_dir+name+'.p','wb') as f:
            pickle.dump(df,f)
        ind += 1


    
def transfer_mongo():
    dbjson = {}
    name = attrs[15].split('.')[0]
    with open(raw_dir+attrs[15]) as f:
        n = 0
        for each in f:
            dbjson[n] = json.loads(each) 
            n += 1 
    with open(clean_dir+name+'.p','wb') as f:
        pickle.dump(dbjson,f)
    
    
def upzip_gz():
    tar = tarfile.open(raw_dir+attrs[16], "r:gz")
    tar.extractall(clean_dir)
    tar.close()

    
if __name__=='__main__':
    #transfer_sql()
    #upzip_gz()
    transfer_mongo()
    
    













