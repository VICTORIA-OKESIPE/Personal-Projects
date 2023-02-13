#!/usr/bin/env python
# coding: utf-8

# In[81]:


import pandas as pd


# In[82]:


import time


# In[83]:


import random


# In[84]:


get_ipython().system('pip install parsel')


# In[85]:


from parsel import Selector


# In[86]:


from time import sleep  # need some time to load some pages when scraping


# In[87]:


from selenium import webdriver


# In[88]:


from selenium.webdriver.common.by import By


# In[89]:


from selenium.webdriver.support.ui import WebDriverWait


# In[90]:


from selenium.webdriver.support import expected_conditions as EC


# In[91]:


from selenium.common.exceptions import TimeoutException


# In[92]:


from selenium.webdriver.chrome.options import Options


# In[93]:


from selenium.webdriver.common.keys import Keys


# In[94]:


opts = Options()


# In[95]:


# you can download your chrome driver from the web
driver = webdriver.Chrome("C:/Users/olaye/AppData/Roaming/Python/Python39/site-packages/chromedriver.exe")


# In[96]:


# function to ensure all key data fields have a value
def validate_field(field):
    # if field is present pass, if field:
    if field:
        pass
    # if filed is NOT present, print text, else:
    else:
        field = "No Results"
    return field


# In[97]:


# driver.get method() will navigate to a page given by the URL address
driver.get("https://www.linkedin.com")

# remember to log into linkedin, you need your email and password
# we need to find particular leys where the email is located


# In[98]:


# locate email form by class name
email = driver.find_element(By.ID, "session_key")


# In[99]:


# send_keys() to simulate key strokes
email.send_keys("victoria.okesipe@gmail.com")


# In[100]:


# sleep for 0.5 seconds
sleep(0.5)


# In[101]:


# locate password form by class name
password = driver.find_element(By.ID, "session_password")


# In[102]:


# send_keys() to simulate key strokes
password.send_keys("dob=03/05/1996")


# In[103]:


# sleep for 0.5 seconds
sleep(0.5)


# In[104]:


# locate submit button by_xpath
sign_in_button = driver.find_element(By.XPATH, '//*[@type="submit"]')


# In[105]:


# .click() to mimic button click
sign_in_button.click()


# In[106]:


# sleep for 0.5 seconds
sleep(0.5)

# and we are done with logging in


# In[107]:


# now to the major items

Jobdata = []
lnks = []


# In[108]:


# sleep for 0.5 seconds
sleep(0.5)


# In[112]:


try:
    driver.get('http://190.109.11.66:8888/BOE/BI')
    wait=WebDriverWait(driver,20)
    time.sleep(5) # give selenium a sleep time
    wait.until(EC.element_to_be_clickable((By.XPATH, '//*[@id="_id0:logon:USERNAME"]')))
except TimeoutException:
    pass


# In[111]:


# getting links for 100 users
for x in range(0,20,10):
    try:
        driver.get(f'https://www.google.com/search?q=linkedin+climate+scientist+uk&ei=6UnqY7SYCdq9gAbP45uABw&ved=0ahUKEwj0sKey25L9AhXaHsAKHc_xBnAQ4dUDCA8&uact=5&oq=linkedin+climate+scientist+uk&gs_lcp=Cgxnd3Mtd2l6LXNlcnAQAzIFCCEQoAEyBQghEKABMgUIIRCgATIECCEQFTILCCEQFhAeEPEEEB0yCwghEBYQHhDxBBAdOgoIABBHENYEELADOgYIABAWEB46CQgAEBYQHhDxBDoFCAAQhgNKBAhBGABKBAhGGABQywZYrQ1glRRoAXABeACAAZgCiAHNBZIBAzItM5gBAKABAcgBBsABAQ&sclient=gws-wiz-serp={x}')
        #time.sleep(random.uniform(2.5, 4.9))
        time.sleep(5) # give selenium a sleep time
        linkedin_urls = [my_elem.get_attribute("href") for my_elem in WebDriverWait(driver, 20).until(EC.visibility_of_all_elements_located((By.XPATH, "//div[@class='yuRUbf']/a[@href]")))]
    lnks.append(linkedin_urls) 
    except TimeoutException:
        pass


# In[ ]:


for x in range(0,20,10):
    driver.get('https://www.google.com/search?q=linkedin+climate+scientist+uk&ei=6UnqY7SYCdq9gAbP45uABw&ved=0ahUKEwj0sKey25L9AhXaHsAKHc_xBnAQ4dUDCA8&uact=5&oq=linkedin+climate+scientist+uk&gs_lcp=Cgxnd3Mtd2l6LXNlcnAQAzIFCCEQoAEyBQghEKABMgUIIRCgATIECCEQFTILCCEQFhAeEPEEEB0yCwghEBYQHhDxBBAdOgoIABBHENYEELADOgYIABAWEB46CQgAEBYQHhDxBDoFCAAQhgNKBAhBGABKBAhGGABQywZYrQ1glRRoAXABeACAAZgCiAHNBZIBAzItM5gBAKABAcgBBsABAQ&sclient=gws-wiz-serp')
    time.sleep(random.uniform(2.5, 4.9))
    linkedin_urls = [my_elem.get_attribute("href") for my_elem in WebDriverWait(driver, 20).until(EC.visibility_of_all_elements_located((By.XPATH, "//div[@class='LHJvCe']/a[@href]")))]
#     time.sleep(5) # give selenium a sleep time
    lnks.append(linkedin_urls)                                                                                            


# In[80]:


for x in range(0,20,10):
    try:
        driver.get('https://www.google.com/search?q=linkedin+climate+scientist+uk&ei=6UnqY7SYCdq9gAbP45uABw&ved=0ahUKEwj0sKey25L9AhXaHsAKHc_xBnAQ4dUDCA8&uact=5&oq=linkedin+climate+scientist+uk&gs_lcp=Cgxnd3Mtd2l6LXNlcnAQAzIFCCEQoAEyBQghEKABMgUIIRCgATIECCEQFTILCCEQFhAeEPEEEB0yCwghEBYQHhDxBBAdOgoIABBHENYEELADOgYIABAWEB46CQgAEBYQHhDxBDoFCAAQhgNKBAhBGABKBAhGGABQywZYrQ1glRRoAXABeACAAZgCiAHNBZIBAzItM5gBAKABAcgBBsABAQ&sclient=gws-wiz-serp={x}')
        time.sleep(random.uniform(2.5, 4.9))
        linkedin_urls = [my_elem.get_attribute("href") for my_elem in WebDriverWait(driver, 20).until(EC.visibility_of_all_elements_located((By.XPATH, "//div[@class='LHJvCe']/a[@href]")))]
#     time.sleep(5) # give selenium a sleep time
    lnks.append(linkedin_urls)       
    except TimeoutException:
        pass
    


# In[68]:


lnks


# In[ ]:


for x in lnks

