#!/usr/bin/env python
# coding: utf-8

# In[9]:


#import packages

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


# In[10]:


#reading data into the jupyter notebook

data = pd.read_csv("marketing_data.csv")
data.head()


# In[11]:


#general information about data
data.info()


# In[12]:


#from data.info() we found that date column needs to be converted to datetime format

data['Date']= pd.to_datetime(data['Date'])

#similarly Income to be converted into float data type but before that we have to delete 
#commas in the income values
data['Income']=data['Income'].str.replace(',','')
data['Income'] = data['Income'].astype(float)


# In[13]:


#check for duplicate records
duplicated_rows = data.duplicated()
duplicated_rows
duplicated_rows.value_counts() #everything is False = no duplicates


# In[14]:


#check for null values
data.isnull().sum()


# In[15]:


#to fill the values of Income with median income values
data['Income'] = data['Income'].fillna(value=data['Income'].median())


# In[16]:


#checking if the null values are filled
data.isnull().sum()


# In[17]:


#getting all unique values of category variables to examine any errors in it
country_var = data.Country.unique()
edu_var = data.Education.unique()
marital_var = data.Marital_Status.unique()


# In[18]:


country_var #all good


# In[19]:


edu_var #2n cycle --> Master


# In[20]:


marital_var #YOLO, Alone, Absurd --> Single


# In[21]:


#transforming 45,43
data['Education']=data['Education'].replace('2n Cycle','Master')
data['Marital_Status']=data['Marital_Status'].replace(['Alone','Master','YOLO'], 'Single')


# In[22]:


#creation of dataframes 

num = ['Year_Birth','Income', 'Recency', 'MntWines', 'MntFruits',
       'MntMeatProducts', 'MntFishProducts', 'MntSweetProducts',
       'MntGoldProds', 'NumDealsPurchases', 'NumWebPurchases',
       'NumCatalogPurchases', 'NumStorePurchases', 'NumWebVisitsMonth']

data_num = data[num]


# In[23]:


#checking numerical variables
data_num.describe()


# In[24]:


#creating boxplots for each column
for column in data_num:
    plt.figure()
    data_num.boxplot([column])                  


# In[25]:


#in birthyear box plots, we can see there are some absurd outliers, for instance, people born before 1900,
#this can be corrected by excluding people born before 1900

data = data[data["Year_Birth"] > 1900]


# In[26]:


data.head()


# In[27]:


sns.distplot(data['Income'])


# In[28]:


#Income range is too long, hence adding log(income) as another column
data["LogIncome"] = np.log(data["Income"])


# In[29]:


#creating aggregated fields

#1 amount spent
data['TotalAmountSpent'] = data['MntWines']+data['MntFruits']+data['MntMeatProducts']+data['MntFishProducts']+data['MntSweetProducts']+data['MntGoldProds']


# In[30]:


#2 products purchased
data['TotalProductsPurchased'] = data['NumWebPurchases'] + data['NumCatalogPurchases'] + data['NumStorePurchases']


# In[31]:


#3 total children
data['TotalChildren'] = data['Kidhome'] + data['Teenhome']


# In[32]:


data['Year_Birth']


# In[33]:


# Creating age bins
data['AgeDemographic']=pd.cut(data['Year_Birth'], bins = [1900,1945,1964,1980,1996,2012], labels = ["Silent Gen", "Baby Boomer", "Gen X","Millennial", "Gen Z"])


# In[34]:


data['AgeDemographic']


# In[35]:


#renaming columns for ease of reading
data = data.rename(columns={"Amount_Spent":"Amount Spent", "Marital_Status":"Marital Status", 
                            "Products_Purchased":"Products Purchased", "Total_Children": "Total Children"})


# In[36]:


#customer demographics
cust_dem = ['AgeDemographic', 'Education', 'Marital Status', 'TotalChildren', 'Country']


# In[37]:


# Make a bar chart that visualizes the number of customers for each demographic using a for loop
for i in cust_dem:
    plt.figure()
    sns.countplot(data[i])
    plt.title(f'Number of customers per {i}')  


# In[38]:


# Make a table showing amount and average spent grouped by each demographic using a for loop
for i in cust_dem:
    c_table = data[[i, "TotalAmountSpent"]].groupby(i).sum()
    c_table["Average Spent"] = data[[i, "TotalAmountSpent"]].groupby(i).mean()
    # Make a bar graph showing amount and average spent grouped by each demographic using a for loop
    for i in c_table.columns:
        plt.figure()
        sns.barplot(x=c_table.index, y=c_table[i])
        plt.title(f'{i}')


# In[39]:


data.info()


# In[40]:


data = data.rename(columns={'MntWines':'Wines', 'MntFruits':'Fruits', 'MntMeatProducts':'Meat', 'MntFishProducts':'Fish', 
                           'MntSweetProducts':'Sweet', 'MntGoldProds':'Gold'})


# In[41]:


data.head()


# In[42]:


# Make table that shows the total amount spent per product category
products = ["Wines", "Fruits", "Meat", "Fish", "Sweet", "Gold"]


# In[43]:


sum=data[products].sum(axis=0)


# In[44]:


plt.figure()
sns.barplot(x=products, y=sum)
plt.title('Total Amount Spent per Category')
plt.xlabel('Product Type')


# In[45]:


for i in cust_dem:
    df = data[[i, "Wines", "Fruits", "Meat", "Fish", "Sweet", "Gold"]].groupby(i).sum()
    df = df.div(df.sum(axis=1), axis=0)*100
    df = df.reset_index()
    df.plot(x=i, kind='barh', stacked = True, mark_right=True)
    plt.title(f"Percentage of sales per product by {i}")


# In[46]:


# Make a table showing the number of purchases accross each sales channel


# In[47]:


data.info()


# In[48]:


data=data.rename(columns={"NumWebPurchases":"Website", 
                          "NumCatalogPurchases":"Catalog", 
                          "NumStorePurchases":"Store"})
sales_channel = ['Website', 'Catalog', 'Store']


# In[49]:


# Make a table showing the number of purchases accross each sales channels
sales_c = data[sales_channel].sum(axis=0)
sales_c = pd.DataFrame(sales_c, columns=["Number of Purchases"])

sns.barplot(x=sales_c.index, y=sales_c["Number of Purchases"])


# In[50]:


#stacked bar plot for purchases per demographic
for i in cust_dem:
    df = data[[i, 'Website', 'Catalog', 'Store']].groupby(i).sum()
    df = df.div(df.sum(axis=1), axis=0)*100
    df = df.reset_index()
    df.plot(x=i, kind='barh', stacked = True, mark_right=True)
    plt.title(f"Percentage of sales per product by {i}")


# In[51]:


#correlation heatmaps
# Make a list of variables to include in the correlation graph
corr_var = ["Year_Birth", "Kidhome", "Teenhome", "Recency", "Wines", 
            "Fruits", "Meat", "Fish", "Sweet", "Gold", 
            "NumDealsPurchases", "Website", "Catalog", "Store", 
            "NumDealsPurchases", "NumWebVisitsMonth", "LogIncome", 
            "TotalAmountSpent", "TotalProductsPurchased", "TotalChildren"]


# In[52]:


corr_var = data[corr_var]


# In[56]:


plt.figure(figsize=(30,20))
sns.heatmap(corr_var.corr(), annot=True)
plt.title("Correlation Heatmap", size=40)

