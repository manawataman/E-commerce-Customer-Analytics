# E-commerce-Customer-Analytics
E-commerce Customer Analytics: To analyze the user purchasing behavior on an e-commerce platform


Context:
Here I have analyzed a dataset of a website users which sells used bikes. 

About the dataset:
The attached dataset is an extract from Elasticsearch index. It 
has both the mapping & data extracts. 

The sample dataset has information about user actions like 
'Product Viewed', '
Added to cart', 
'Checkout made', 
'User registered', 
'pageview'. T

About mapping:
The dataset has self explaining field names. The data in some fields are simple string while others are nested objects. 

traits - This nested object has personal information about a user like name, email, phone, etc.
cl_utm_params & cl_other_params - These are the url parameters of the webpage the user is visiting.
attributes - This object has data about an action the user is performing(eg: if the action is pageview, we send the url the user has viewed in the attributes)
products - This object has info about the products for which the action is taken(eg: if the action is product viewed, we send the data about the product he has viewed in this object).
cl_triggered_ts - This is the time the user has performed the action.
user_id - Unique id of a user.
session_id - Unique id of a user's session


