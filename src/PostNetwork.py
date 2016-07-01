#-*-coding: utf8 -*-
"""
Created on Fri Jul 01 14:36:00 2016

@author: Ziwei Meng

Package name: PostNetwork

various functions for preparing network analysis

TODO: integrate into a class instead of functions 
      use *kargs to control flows
      modify dataframe_to_graph by sql queries

"""

from pymongo import MongoClient
import pandas as pd
import subprocess
from collections import Counter
import networkx as nx




def connect_server(my_dbpath="C:/database_mongo"):
    '''
    arg:
    my_dbpath: your mongodb database path
    '''
    subprocess.call(["mongod","--dbpath="+my_dbpath])
    
def close_server(): 
    subprocess.call(["mongo","--eval","db.getSiblingDB('admin').shutdownServer()"])

def create_dataframe(ind=0):
    '''
    arg:
    ind: you want to use the n-th collection in the collection list  
    
    output:
    df: a dataframe generated from n-th mongodb collection
    '''
    client = MongoClient()
    db = client.test
    collection_name = db.collection_names()[ind]
    cursor = eval('db.'+collection_name+'.find({})')
    mong = []
    for document in cursor:
        mong.append(document)
    df = pd.DataFrame.from_dict(mong)
    return df 


    
def create_maps(df,link):
    '''
    arg:
    df: the dataframe generated from mongodb 
    link: the column name which links each comment to its parent comment/comment thread
    
    output:
    valid_submap: map i-th post without missing value to its id, link, and author id 
    valid_authormap: map each post id to its author id, where each post is the parent or thread of some post in valid_submap
    '''
    valid_subdf = df[['_id',link,'author_id']].dropna()
    valid_submap = {i:{'_id':str(valid_subdf.iloc[i]['_id']),link:str(valid_subdf.iloc[i][link]),
             'author_id':str(valid_subdf.iloc[i]['author_id'])} for i in range(valid_subdf.shape[0])}
    
    valid_author = df[df['_id'].isin(valid_subdf[link])][['_id','author_id']]
    valid_authormap = {str(valid_author.iloc[i]['_id']):str(valid_author.iloc[i]['author_id']) for i in range(valid_author.shape[0])}
    return [valid_submap, valid_authormap]
    
    
    
def create_edges(df,link):
    '''
    args:
    link: the column name which links each comment to its parent comment/comment thread   

    output:
    edges: dictionary (author_id, linked_author_id): number_of_links   
    '''
    submap,authormap = create_maps(df,link)
    edges = []
    for each in submap:
        edges.append((submap[each]['author_id'],authormap[submap[each][link]]))
    edges = Counter(edges)
    return edges
    



def create_authors(df,link):
    '''
    arg:
    link: the column name which links each comment to its parent comment/comment thread
    
    output:
    authors: set of all author ids involved in link-communication
    '''
    edges = create_edges(df,link)
    authors = set([x for pair in edges.keys() for x in pair ])
    return authors
    
    
    
    
    
    
def create_vertice_index(df,authors):
    '''
    arg:
    link: the column name which links each comment to its parent comment/comment thread 
    
    output:
    author_index: map each author_id to an int
    '''
    #authors = create_authors(df,link)
    author_index = {x:i for i,x in enumerate(authors)}
    return author_index


    
def create_graph_map(df,author_index,link):
    '''
    args:
    link: the column name which links each comment to its parent comment/comment thread 

    output:
    graphmap: list of tuples (author_index, author_index, number_of_communications)    
    '''
    #author_index = create_vertice_index(df,link)
    edges = create_edges(df,link)
    graphmap = [(author_index[edges.keys()[i][0]],author_index[edges.keys()[i][1]],
      float(edges[edges.keys()[i]])) 
      for i in range(len(edges))]
    return graphmap
    

def merge_graph_map(map1,map2):
    map1 = {x[:2]:x[2] for x in map1}
    map2 = {x[:2]:x[2] for x in map2} 
    map = map2 
    for pair in map1:
        if pair not in map:
            map[pair] = map1[pair]
        else:
            map[pair] += map1[pair]
    map = [(x[0],x[1],map[x]) for x in map]
    return map     
    
    
def dataframe_to_graph(df,typ='comment'):
    '''
    args:
    df: the dataframe from which you want to generate a graph
    type: one of ['comment', 'commentthread', 'mixture']
    
    output:
    DG: a directed graph of post-and-reply network
    '''
    graph_links = {'comment':'parent_id', 'commentthread':'comment_thread_id', 'mixture':['parent_id','comment_thread_id']}
    if typ in graph_links:
        link = graph_links[typ]   
    else:
        raise ValueError("Not a valid graph type, please select from 'comment', 'commentthread' or 'mixture'.")
    authors = set()
    for l in ['parent_id','comment_thread_id']:
        authors = authors.union(create_authors(df,l))
    author_index = create_vertice_index(df,authors)
    
    
    if link in ['parent_id','comment_thread_id']:
        gmap = create_graph_map(df,author_index,link)
    else:
        gmap = merge_graph_map(create_graph_map(df,author_index,link[0]),create_graph_map(df,author_index,link[1]))
        
        
    DG = nx.DiGraph()
    DG.add_weighted_edges_from(gmap)
    return DG 
    
        
            
       
             
             














if __name__ == '__main__':
    connect_server()
    dataframe = create_dataframe()
    DG_c = dataframe_to_graph(dataframe,typ='comment')
    DG_t = dataframe_to_graph(dataframe,typ='commentthread')
    DG_m = dataframe_to_graph(dataframe,typ='mixture')
    close_server()
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
