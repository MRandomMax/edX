# edX
Summer edX analytics

## General Info
#### Dataset Overview  
Each course has 17 files (as in google doc), including:  
1. 1 .mongo file containing forum discussion data   
2. 1 .json file containing course structure info  
3. 14 .sql file of user/course/enrollment, etc  
4. 1 zip file of detailed info about data

#### Data fields:  
For a detailed documentation please see [EdX Research Guide, Ch2. Data Reference](http://edx.readthedocs.io/projects/devdata/en/latest/internal_data_formats/index.html)  
**Crutial bits:**   
1. Many fields are obsolete and no longer used. Many seemingly useful fields have actually no records.  
2. The .sql files are sql output. Due to Django framework used by edX, many NULL values are displayed as blanks.  
3. For codes to read all .sql data into dataframe in R (removing columns with all NULLs) please find read_sql.R in lib folder.  
4. Some files (at least for the course I was working on) do not have any records in it. I chose not to save them at all.

### You can start playing with Tableau. But I guess we need to brainstorm some directions or further ways to treat/clean the data.

## Reference:  
[Edx Research Guide](http://edx.readthedocs.io/projects/devdata/en/latest/)
