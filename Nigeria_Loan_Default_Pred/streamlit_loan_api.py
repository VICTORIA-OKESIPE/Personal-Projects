import pandas as pd
import numpy as np
import streamlit as strrr
from xgboost import XGBClassifier
from sklearn.preprocessing import StandardScaler

#Loading up the classifier model we created
XGB_tuned = XGBClassifier()
XGB_tuned.load_model('xgb_model.json')

#Caching the model for faster loading
#@st.cache

# preprocessing input data
scaler = StandardScaler()


#=== Let's make predictions # Define the prediction function
def predict(bank_account_type, longitude_gps, latitude_gps, bank_name_clients, employment_status_clients,
       level_of_education_clients, loanamount, totaldue, termdays, age):
    #Predicting the loan borrower's behaviour
    if bank_account_type == 'Current':
        bank_account_type = 0
    elif bank_account_type == 'Other':
        bank_account_type = 1
    elif bank_account_type == 'Savings':
        bank_account_type = 2
        
        
    if bank_name_clients == 'Access Bank':
        bank_name_clients = 0
    elif bank_name_clients == 'Diamond Bank':
        bank_name_clients = 1
    elif bank_name_clients == 'EcoBank':
        bank_name_clients = 2
    elif bank_name_clients == 'FCMB':
        bank_name_clients = 3
    elif bank_name_clients == 'Fidelity Bank':
        bank_name_clients = 4
    elif bank_name_clients == 'First Bank':
        bank_name_clients = 5
    elif bank_name_clients == 'GT Bank':
        bank_name_clients = 6
    elif bank_name_clients == 'Heritage Bank':
        bank_name_clients = 7
    elif bank_name_clients == 'Keystone Bank':
        bank_name_clients = 8
    elif bank_name_clients == 'Skye Bank':
        bank_name_clients = 9
    elif bank_name_clients == 'Stanbic IBTC':
        bank_name_clients = 10
    elif bank_name_clients == 'Standard Chartered':
        bank_name_clients = 11
    elif bank_name_clients == 'Sterling Bank':
        bank_name_clients = 12
    elif bank_name_clients == 'UBA':
        bank_name_clients = 13
    elif bank_name_clients == 'Union Bank':
        bank_name_clients = 14
    elif bank_name_clients == 'Unity Bank':
        bank_name_clients = 15
    elif bank_name_clients == 'Wema Bank':
        bank_name_clients = 16
    elif bank_name_clients == 'Zenith Bank':
        bank_name_clients = 17

    
    if employment_status_clients == 'Contract':
        employment_status_clients = 0
    elif employment_status_clients == 'Permanent':
        employment_status_clients = 1
    elif employment_status_clients == 'Retired':
        employment_status_clients = 2
    elif employment_status_clients == 'Self-Employed':
        employment_status_clients = 3
    elif employment_status_clients == 'Student':
        employment_status_clients = 4
    elif employment_status_clients == 'Unemployed':
        employment_status_clients = 5


    if level_of_education_clients == 'Secondary':
        level_of_education_clients = 0
    elif level_of_education_clients == 'Post-Graduate':
        level_of_education_clients = 1
    elif level_of_education_clients == 'Primary':
        level_of_education_clients = 2
    elif level_of_education_clients == 'Graduate':
        level_of_education_clients = 3
        
        
    if termdays == '15 days':
        termdays = 0
    elif termdays == '30 days':
        termdays = 1
    elif termdays == '60 days':
        termdays = 2
    elif termdays == '90 days':
        termdays = 3
        
        
    scaler.fit_transform(np.array(longitude_gps).reshape(-1, 1))
    scaler.fit_transform(np.array(latitude_gps).reshape(-1, 1))
    scaler.fit_transform(np.array(loanamount).reshape(-1, 1))
    scaler.fit_transform(np.array(totaldue).reshape(-1, 1))
    scaler.fit_transform(np.array(age).reshape(-1, 1))
    

    prediction = XGB_tuned.predict(pd.DataFrame([[bank_account_type, longitude_gps, latitude_gps, bank_name_clients, employment_status_clients, level_of_education_clients, loanamount, totaldue, termdays, age]], columns=['bank_account_type','longitude_gps', 'latitude_gps','bank_name_clients', 'employment_status_clients', 'level_of_education_clients', 'loanamount', 'totaldue','termdays', 'age']))
    return prediction

#=== writing the Predictor App
st.title('Predictor App: Loan Repayment Behaviour')
st.image("""https://miro.medium.com/v2/resize:fit:1200/0*8YE6hEXyYBjF5bei.jpg""")
st.header('Enter the customer details:')
bank_account_type = st.selectbox('Select the Bank Account Type:', ('Current', 'Other', 'Savings'))
longitude_gps = st.slider('Select the Longitude in degrees:', min_value=-180.0, max_value=180.0, step=0.1)
latitude_gps = st.slider('Select the Longitude in degrees:', min_value=-90.0, max_value=90.0, step=0.1)
bank_name_clients = st.selectbox('Select the Bank Name:', ('Access Bank', 'Diamond Bank', 'EcoBank', 'FCMB',
       'Fidelity Bank', 'First Bank', 'GT Bank', 'Heritage Bank', 'Keystone Bank',
       'Skye Bank', 'Stanbic IBTC', 'Standard Chartered', 'Sterling Bank',
       'UBA', 'Union Bank', 'Unity Bank',
       'Wema Bank', 'Zenith Bank'))
employment_status_clients = st.selectbox('Select the Employment Status:', ('Contract', 'Permanent', 'Retired', 'Self-Employed', 'Student',
       'Unemployed'))
level_of_education_clients = st.selectbox('Select the Level of Education:', ('Secondary', 'Post-Graduate', 'Primary', 'Graduate'))
loanamount = st.number_input('Enter the Loan Amount:', min_value=10000.0, max_value=70000.0, step=100.0)
totaldue = st.number_input('Enter the Total Due:', min_value=10000.0, max_value=70000.0, step=100.0)
termdays = st.selectbox('Select the Term Days:', ('15 days', '30 days', '60 days', '90 days'))
age = st.number_input('Enter the Age:', min_value=0, max_value=120, step=1)

if st.button('Predict Loan Repayment Behaviour'):
    flag = predict(bank_account_type, longitude_gps, latitude_gps, bank_name_clients, employment_status_clients, level_of_education_clients, loanamount, totaldue, termdays, age)
    if flag[0] == 1:
        st.success("Congratulations! Your loan is Approved.")
    else:
        st.success("We are sorry! You didn't meet our criteria.")
    #st.success(f'The predicted loan repayment behaviour is ${flag[0]:.2f}')
    #st.success(f'The predicted loan repayment behaviour is {flag[0]}')

    
    
