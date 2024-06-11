import streamlit as st
import psycopg2
import os
# import toml

# Load the secrets.toml configuration
# config = toml.load('C:/Users/v-sujal.sethi/Downloads/lagozon assiatant_postersql/.streamlit/secrets.toml')
# sql_config = config['connections']['postgresql']

# # PostgreSQL connection string
# connection_string = f"dbname={sql_config['database']} user={sql_config['user_id']} password={sql_config['password']} host={sql_config['server']} port={sql_config['port']} sslmode={sql_config['sslmode']}"

# Fetch database configuration from environment variables
DBNAME = os.environ.get('DBNAME')
DBUSER = os.environ.get('DBUSER')
DBPASSWORD = os.environ.get('DBPASSWORD')
DBHOST = os.environ.get('DBHOST')
DBPORT = os.environ.get('DBPORT')
SSL_MODE = os.environ.get('SSL_MODE', 'require')  # Default to 'require' if not specified

# Construct the connection string for PostgreSQL
connection_string = f"""
dbname={DBNAME} user={DBUSER} password={DBPASSWORD} 
host={DBHOST} port={DBPORT} sslmode={SSL_MODE}
"""
# Define qualified table names for different departments
SALES_QUALIFIED_TABLE_NAME = "lz_foods"
HR_QUALIFIED_TABLE_NAME = "lz_employees"
CUSTOMER_QUALIFIED_TABLE_NAME = "lz_customers"
FINANCE_QUALIFIED_TABLES = ["lz_invoices", "lz_receipts"]

# Medical tables
MEDICAL_QUALIFIED_TABLES = [
    "lz_radiology_reports",
    "lz_radiology_exams",
    "lz_nurses",
    "lz_doctors",
    "lz_patients",
    "lz_departments"
]

#Added Manufacturing by Aruna on 11/06
MANUFACTURING_QUALIFIED_TABLES = [
    "lz_items",
    "lz_iten_trx",
    "lz_item_onhand"    
]


# Define table descriptions for different departments
SALES_TABLE_DESCRIPTION = """
The dataset contains sales data for various stores, including total sales, orders, and sales distribution across different channels.
"""
HR_TABLE_DESCRIPTION = """
The dataset contains HR-related data such as employee information, salaries, and hire dates.
"""
CUSTOMER_TABLE_DESCRIPTION= """
The customer table contains essential information such as Customer ID, First Name, Last Name, Email Address, and Phone Number, facilitating customer management and communication.
"""
FINANCE_TABLE_DESCRIPTION = """
The finance dataset includes invoice and receipt data. The invoice table contains information about invoices such as customer ID, invoice date, due date, and total amount. The receipt table contains payment details linked to invoices, including receipt date, payment amount, payment method, and payment status.
"""
MEDICAL_TABLE_DESCRIPTION = """
The medical department's dataset includes various tables related to radiology reports, exams, doctors, nurses, patients, and departments.
"""

#Added Manufacturing by Aruna on 11/06
MANUFACTURING_TABLE_DESCRIPTION = """
The manufacturing department's dataset includes various tables related to items, item transactions and item on-hand quantity.
"""


GEN_SQL = """
I'm Lagozon, your SQL Server Expert Assistant. I'm here to help you with SQL queries tailored to your needs.
{context}

Here are 5 critical rules for the interaction you must abide:
<rules>
1. You MUST MUST wrap the generated sql code within ``` sql code markdown in this format e.g
```sql
(select 1) union (select 2)
```
2. If I don't tell you to find a limited set of results in the sql query or question, you MUST limit the number of responses to 10.
3. Text / string where clauses must be fuzzy match e.g ilike %keyword%
4. You should only use the table columns given in <columns>, and the table given in <tableName>, you MUST NOT hallucinate about the table names
5. DO NOT put numerical at the very front of sql variable.
</rules>

Don't forget to use "ilike %keyword%" for fuzzy match queries (especially for variable_name column)
and wrap the generated sql code with ``` sql code markdown in this format e.g:
```sql
(select 1) union (select 2)
```

For each question from the user, make sure to include a query in your response.

Now to get started, please briefly introduce yourself as a Helping Chatbot not more than one line, donot mention table name.

"""

# Database connection function
@st.cache(allow_output_mutation=True)
def get_connection():
    return psycopg2.connect(connection_string)


# Retrieve table context based on department
@st.cache_data(show_spinner="Loading department context...")
def get_table_context(department: str):
    if department == "Sales":
        return SALES_QUALIFIED_TABLE_NAME, SALES_TABLE_DESCRIPTION
    elif department == "HR":
        return HR_QUALIFIED_TABLE_NAME, HR_TABLE_DESCRIPTION
    elif department == "customer":
        return CUSTOMER_QUALIFIED_TABLE_NAME, CUSTOMER_TABLE_DESCRIPTION
    elif department == "Finance":
        return FINANCE_QUALIFIED_TABLES, FINANCE_TABLE_DESCRIPTION
    elif department == "Medical":
        return MEDICAL_QUALIFIED_TABLES, MEDICAL_TABLE_DESCRIPTION
    #Added Manufacturing by Aruna on 11/06
    elif department == "Manufacturing":
        return MANUFACTURING_QUALIFIED_TABLES, MANUFACTURING_TABLE_DESCRIPTION
    else:
        return None, None

def generate_gpt_response(user_input, department):
    qualified_table_name, _ = get_table_context(department)
    if qualified_table_name:
        connection = get_connection()
        cursor = connection.cursor()
        # Example query, adapt as needed
        sql_query = f"SELECT * FROM {qualified_table_name} WHERE your_condition LIMIT 10"
        cursor.execute(sql_query)
        results = cursor.fetchall()
        # Further processing of results as needed
        cursor.close()
        return results
    else:
        return None

def get_system_prompt(department):
    qualified_table_name, table_description = get_table_context(department)
    if qualified_table_name:
        if department == "Sales":
            columns_description = """
           - **STORE_ID**: VARCHAR
           - **BUSINESS_MONTH**: VARCHAR
           - **TOTAL_SALES**: FLOAT
           - **TOTAL_ORDER**: INT
           - **DELIVERY_SALES**: FLOAT
           - **NON_DELIVERY_SALES**: FLOAT
           - **DELIVERY_ORDER**: INT
           - **NON_DELIVERY_ORDER**: INT
           - **DINEIN_SALES**: FLOAT
           - **DINEIN_ORDER**: INT
           - **TAKEAWAY_SALES**: FLOAT
           - **TAKEAWAY_ORDER**: INT
           - **DNP_SALES**: FLOAT
           - **DNP_ORDER**: FLOAT
           - **SWIGGY_DELIVERY_SALES**: FLOAT
           - **SWIGGY_DELIVERY_ORDER**: INT
           - **ZOMATO_DELIVERY_SALES**: FLOAT
           - **ZOMATO_DELIVERY_ORDER**: INT
           - **AMAZON_FOODS_DELIVERY_SALES**: FLOAT
           - **AMAZON_FOODS_DELIVERY_ORDER**: INT
           - **AMAZON_FOODS_DINEIN_SALES**: FLOAT
           - **AMAZON_FOODS_DINEIN_ORDER**: INT
           - **AMAZON_FOODS_TAKEAWAY_SALES**: FLOAT
           - **AMAZON_FOODS_TAKEAWAY_ORDER**: INT
           - **GPAY_DELIVERY_SALES**: FLOAT
           - **GPAY_DELIVERY_ORDER**: INT
           - **GPAY_DINEIN_SALES**: FLOAT
           - **GPAY_DINEIN_ORDER**: INT
           - **GPAY_TAKEAWAY_SALES**: FLOAT
           - **GPAY_TAKEAWAY_ORDER**: INT
           - **PAYTM_MICROAPP_DELIVERY_SALES**: FLOAT
           - **PAYTM_MICROAPP_DELIVERY_ORDER**: INT
           - **PAYTM_MICROAPP_TAKEAWAY_SALES**: FLOAT
           - **PAYTM_MICROAPP_TAKEAWAY_ORDER**: INT
           - **PAYTM_MICROAPP_DINEIN_SALES**: FLOAT
           - **PAYTM_MICROAPP_DINEIN_ORDER**: INT
           - **PHONEPE_DELIVERY_SALES**: FLOAT
           - **PHONEPE_DELIVERY_ORDER**: INT
           - **DESKTOP_DELIVERY_SALES**: FLOAT
           - **DESKTOP_DELIVERY_ORDER**: INT
           - **DESKTOP_TAKEAWAY_SALES**: FLOAT
           - **DESKTOP_TAKEAWAY_ORDER**: INT
           - **IRCTC_DELIVERY_SALES**: FLOAT
           - **IRCTC_DELIVERY_ORDER**: INT
           - **NEW_APP_ANDROID_DELIVERY_SALES**: FLOAT
           - **NEW_APP_ANDROID_DELIVERY_ORDER**: INT
           - **NEW_APP_ANDROID_DINEIN_SALES**: FLOAT
           - **NEW_APP_ANDROID_DINEIN_ORDER**: INT
           - **NEW_APP_ANDROID_DRIVE_PICK_SALES**: FLOAT
           - **NEW_APP_ANDROID_DRIVE_PICK_ORDER**: INT
           - **NEW_APP_ANDROID_TAKEAWAY_SALES**: FLOAT
           - **NEW_APP_ANDROID_TAKEAWAY_ORDER**: INT
           - **NEW_APP_IPHONE_DELIVERY_SALES**: FLOAT
           - **NEW_APP_IPHONE_DELIVERY_ORDER**: INT
           - **NEW_APP_IPHONE_DRIVE_PICK_SALES**: FLOAT
           - **NEW_APP_IPHONE_DRIVE_PICK_ORDER**: INT
           - **NEW_APP_IPHONE_TAKEAWAY_SALES**: FLOAT
           - **NEW_APP_IPHONE_TAKEAWAY_ORDER**: INT
           - **PWA_DELIVERY_SALES**: FLOAT
           - **PWA_DELIVERY_ORDER**: INT
           - **PWA_DINEIN_SALES**: FLOAT
           - **PWA_DINEIN_ORDER**: INT
           - **PWA_TAKEAWAY_SALES**: FLOAT
           - **PWA_TAKEAWAY_ORDER**: INT
           - **CALL_CENTER_DELIVERY_SALES**: FLOAT
           - **CALL_CENTER_DELIVERY_ORDER**: INT
           - **CALL_CENTER_TAKEAWAY_SALES**: FLOAT
           - **CALL_CENTER_TAKEAWAY_ORDER**: INT
           - **PHONE_DELIVERY_SALES**: FLOAT
           - **PHONE_DELIVERY_ORDER**: INT
           - **DINEIN_CHANNEL_SALES**: FLOAT
           - **DINEIN_CHANNEL_ORDER**: INT
           - **ODC_DINEIN_SALES**: FLOAT
           - **ODC_DINEIN_ORDER**: INT
           - **DINEIN_TAKEAWAY_SALES**: FLOAT
           - **DINEIN_TAKEAWAY_ORDER**: INT
           - **KIOSK_DINEIN_SALES**: FLOAT
           - **KIOSK_DINEIN_ORDER**: INT
           - **KIOSK_TAKEAWAY_SALES**: FLOAT
           - **KIOSK_TAKEAWAY_ORDER**: INT
           - **OLD_APP_ANDROID_TAKEAWAY_SALES**: FLOAT
           - **OLD_APP_ANDROID_TAKEAWAY_ORDER**: INT
           - **OLD_APP_IPHONE_TAKEAWAY_SALES**: FLOAT
           - **OLD_APP_IPHONE_TAKEAWAY_ORDER**: INT

            
            """
        elif department == "HR":
            columns_description = """
            - **EmployeeID**: Employee ID
            - **FULLNAME**: Full Name
            - **FirstName**: First Name
            - **LastName**: Last Name
            - **Email**: Email Address
            - **Department**: Department Name
            - **JobTitle**: Job Title
            - **HireDate**: Date of Hire
            - **Salary**: Salary
            """
        elif department == "customer":
            columns_description = """
            - **CustomerID**: Customer ID
            - **FirstName**: First Name
            - **LastName**: Last Name
            - **Email**: Email Address
            - **PhoneNumber**: Phone Number
            """
        elif department == "Finance":
            columns_description = """
            **lz_invoices**
            - **InvoiceID**: Invoice ID
            - **CustomerID**: Customer ID
            - **InvoiceDate**: Invoice Date
            - **DueDate**: Due Date
            - **TotalAmount**: Total Amount

            **lz_receipts**
            - **ReceiptID**: Receipt ID
            - **InvoiceID**: Invoice ID
            - **ReceiptDate**: Receipt Date
            - **PaymentAmount**: Payment Amount
            - **PaymentMethod**: Payment Method
            - **PaymentReference**: Payment Reference
            - **PaymentStatus**: Payment Status
            """
        elif department == "Medical":
            columns_description = """
            **LZ_Departments**
            - **DepartmentID**: Department ID
            - **DepartmentName**: Department Name
            
            **LZ_Doctors**
            - **DoctorID**: Doctor ID
            - **FirstName**: First Name
            - **LastName**: Last Name
            - **DepartmentID**: Department ID
            - **Specialty**: Specialty
            - **LicenseNumber**: License Number
            
            **LZ_Patients**
            - **PatientID**: Patient ID
            - **FirstName**: First Name
            - **LastName**: Last Name
            - **DateOfBirth**: Date of Birth
            - **Gender**: Gender
            
            **LZ_Nurses**
            - **NurseID**: Nurse ID
            - **FirstName**: First Name
            - **LastName**: Last Name
            - **DepartmentID**: Department ID
            
            **LZ_Radiology_Exams**
            - **ExamID**: Exam ID
            - **PatientID**: Patient ID
            - **ExamType**: Exam Type
            - **ExamDate**: Exam Date
            - **ReferringPhysician**: Referring Physician
            - **ExamStatus**: Exam Status
            
            **LZ_Radiology_Reports**
            - **ReportID**: Report ID
            - **ExamID**: Exam ID
            - **Radiologist**: Radiologist
            - **ReportDate**: Report Date
            - **ReportText**: Report Text
            """
        #Added Manufacturing by Aruna on 11/06
        elif department == "Manufacturing":
            columns_description = """
            **lz_items**
            - **InventoryItemId**: Inventory Item Id
            - **ItemNumber**: Item Number
            - **ItemType**: Item Type
            - **Description**: Description
            - **UomCode**: Uom Code
            - **Segment1**: Segment1
            - **Segment2**: Segment2
 
            **lz_iten_trx**
            - **ItemTrxId**: ItemTrxId
            - **TransactionTypeCode**: Transaction Type Code
            - **TransactionDate**: Transaction Date
            - **ItemId**: Item Id
            - **TransactionQty**: Transaction Qty
            - **FromSubInvCode**: From SubInv Code
            - **ToSubInvCode**: To SubInv Code

            **lz_item_onhand**
            - **InventoryItemId**: Inventory Item Id
            - **SubInventoryCode**: SubInventory Code
            - **OnHandQuantity**: OnHand Quantity
            - **LastUpdateDate**: Last Update Date
            """
        else:
            columns_description = "No columns available."
    
        
        context = f"""
        Here is the table name: {qualified_table_name}

        Table Description: {table_description}

        Columns:
        {columns_description}
        """
        return context
    else:
        return "Sorry, you do not have access to this data. Please switch your role."

        

if __name__ == "__main__":
    st.header("Prompt Engineering for Lagozon")
    #Added Manufacturing by Aruna on 11/06
    department = st.selectbox("Select department:", ["Sales", "HR", "customer", "Finance", "Medical", "Manufacturing"])
    st.markdown(get_system_prompt(department))
