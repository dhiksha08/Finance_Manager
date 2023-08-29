import mysql.connector

# Function to check user credentials
def check_user(userid, password):

    cursor.callproc('check_user', (userid, password))
    result = next(cursor.stored_results()).fetchone()[0]
    
    return result


# Function to select a user by user ID
def select_user(userid): 
    cursor.callproc('select_user', (userid,))
    for result in cursor.stored_results():
        users = result.fetchall()
        if len(users) > 0:
            print("User found:")
            print("User ID: {}".format(users[0][0]))
            print("Username: {}".format(users[0][1]))
            print("Password: {}".format(users[0][2]))
            print("Phone number: {}".format(users[0][3]))
            print("Email: {}".format(users[0][4]))
        else:
            print("User not found.")
    
# Function to update username
def update_username(userid):
    new_username = input("Enter new username: ")
    
    cursor.callproc('update_username', (userid, new_username))
    cnx.commit()
    print("Username updated successfully!")
    
# Function to update password
def update_password(userid):
    new_password = input("Enter new password: ")
    
    cursor.callproc('update_password', (userid, new_password))
    cnx.commit()
    print("Password updated successfully!")
    
# Function to update email
def update_email(userid):
    new_email = input("Enter new email: ")
    
    cursor.callproc('update_email', (userid, new_email))
    cnx.commit()
    print("Email updated successfully!")
    
# Function to update phone number
def update_phone_no(userid):
    new_phone_no = input("Enter new phone number: ")
    
    cursor.callproc('update_phone_no', (userid, new_phone_no))
    cnx.commit()
    print("Phone number updated successfully!")
    
    
def delete_user(userid):
    cursor.callproc('delete_user',(userid,))
    cnx.commit()
    
    
def display_expenses(userid):
    cursor.callproc('select_expenses', [userid])
    for expenses in cursor.stored_results():
        expense = expenses.fetchall()
        for i in range(0,len(expense)):
            print(f"Spend ID: {expense[i][0]}, Date: {expense[i][2]}, Item Name: {expense[i][3]}, Category: {expense[i][4]}, Amount: {expense[i][5]}, Notes: {expense[i][6]}")

        
    
# Define function to add a new expense
def add_expense(userid):
    item_name = input("Enter item name: ")
    category = input("Enter category: ")
    amount = float(input("Enter amount: "))
    notes = input("Enter notes: ")
    cursor.callproc('insert_expense', [userid, '2023-03-29', amount, item_name, category, notes])
    cnx.commit()
    print("Expense added successfully")

# Define function to delete an expense
def delete_expense(userid):
    spend_id = int(input("Enter spend ID to delete: "))
    cursor.callproc('delete_expense', [spend_id, userid])
    cnx.commit()
    print("Expense deleted successfully")
    
    
def insert_loan(user_id):
    loan_no = input("Enter loan number: ")
    amount = input("Enter amount: ")
    due_date = input("Enter due date (yyyy-mm-dd): ")
    interest_rate = input("Enter interest rate: ")
    bank_name = input("Enter bank name: ")

    # Calling the insert_loan stored procedure
    cursor.callproc("insert_loan", [loan_no, amount, due_date, interest_rate, bank_name, user_id])
    cnx.commit()

    print("Loan inserted successfully.")

# Function to display loans for a given user ID
def select_loans_by_userid(user_id):
    
    # Calling the select_loans_by_userid stored procedure
    cursor.callproc("select_loans_by_userid", [user_id])
    for loans in cursor.stored_results():
        loan = loans.fetchall()
        for i in range(0,len(loan)):
                print(f"Loan No: {loan[i][0]}, Amount: {loan[i][2]}, Due_Date: {loan[i][3]}, Interest_Rate: {loan[i][4]}, Bank_Name: {loan[i][5]}")

# Function to update the amount for a loan
def update_loan_amount(user_id):
    
    loan_no = input("Enter loan number: ")
    new_amount = input("Enter new amount: ")
    bank_name = input("Enter bank name: ")

    # Calling the update_loan_amount stored procedure
    cursor.callproc("update_loan_amount", [loan_no, user_id, new_amount,bank_name])
    cnx.commit()

    print("Loan updated successfully.")

# Function to update the due date for a loan
def update_due_date(user_id):
    
    loan_no = input("Enter loan number: ")
    new_due_date = input("Enter new due date (yyyy-mm-dd): ")
    bank_name = input("Enter bank name: ")

    # Calling the update_due_date stored procedure
    cursor.callproc("update_due_date", [user_id, loan_no, new_due_date,bank_name])
    cnx.commit()

    print("Loan due date updated successfully.")

# Function to delete a loan
def delete_loan(user_id):

    loan_no = input("Enter Loan No: ")
    bank_name = input("Enter bank name: ")

    # Calling the delete_loan stored procedure
    cursor.callproc("delete_loan", [loan_no, user_id,bank_name])
    cnx.commit()

    print("Loan deleted successfully.")

    
    
    
    
# Define a function for inserting a new row into the "insurance" table
def insert_insurance(user_id):
    
    insurance_id = int(input("Enter insurance ID: "))
    type_insurance = input("Enter type of insurance: ")
    id_holder_name = input("Enter ID holder name: ")
    holder_id = int(input("Enter holder ID: "))
    expiry = input("Enter expiry date (YYYY-MM-DD): ")
    amount_paid = float(input("Enter amount paid: "))
    agent = input("Enter agent name: ")
    cursor = cnx.cursor()
    cursor.callproc("insert_insurance", (user_id, insurance_id, type_insurance, id_holder_name, holder_id, expiry, amount_paid, agent))
    cnx.commit()
    print("Insurance inserted successfully!")

# Define a function for deleting rows from the "insurance" table based on user ID
def delete_insurance(user_id):

    cursor = cnx.cursor()
    cursor.callproc("delete_insurance", (user_id,))
    cnx.commit()
    print("Deleted successfully!")

# Define a function for displaying rows from the "insurance" table based on user ID
def display_insurance(user_id):
    
    
    cursor = cnx.cursor()
    cursor.callproc("display_insurance", (user_id,))
    for insurances in cursor.stored_results():
        insurance = insurances.fetchall()
        for i in insurance:
            print(i)
    
    
def insert_user():
    username = input("Enter username: ")
    password = input("Enter password: ")
    phone_no = input("Enter phone number: ")
    email = input("Enter email: ")
    
    cursor.callproc('insert_user', (username, password, phone_no, email))
    cnx.commit()
    print("User inserted successfully!") 
    query = "SELECT userid FROM user ORDER BY userid DESC LIMIT 1"
    cursor.execute(query)


    result = cursor.fetchone()
    last_user_id = result[0]
    print('Your user id is ',last_user_id)
    
    
# Establish MySQL connection

cnx = mysql.connector.connect(host="host name",user="user name",passwd="please add the password",database="database name")
cursor=cnx.cursor()
# Get user input for user ID and password
print("1. Login")
print("2. Sign Up")
ch = int(input("Enter your choice: "))
if (ch==1):

    userid = int(input("Enter user ID: "))
    password = input("Enter password: ")

    # Call check_user stored procedure to validate user credentials
    result = check_user(userid, password)
    print(result)
    #result=1
    if result == 1:
        # Display menu options for CRUD operations
        while True:
            print("1. Go to Expense")
            print("2. Check your profile")
            print("3. Update Username")
            print("4. Update Password")
            print("5. Update Email")
            print("6. Update Phone Number")
            print("7. Delete your account")
            print("8. Go to Loan")
            print("9. Go to Insurance")
            print("10. Exit")
            choice = input("Enter your choice: ")

            if choice=='1':
                while True:
                    print("1. Display expenses")
                    print("2. Add new expense")
                    print("3. Delete expense")
                    print("4. Exit")
                    choice1 = input("Enter your choice: ")
                    if choice1 == "1":
                        display_expenses(userid)

                    elif choice1 == "2":
                        add_expense(userid)

                    elif choice1 == "3":
                        delete_expense(userid)

                    elif choice1 == "4":
                        print("Exiting program")
                        break

                    else:
                        print("Invalid choice, please try again")


            elif choice == '2':
                select_user(userid)
            elif choice == '3':
                update_username(userid)
            elif choice == '4':
                update_password(userid)
            elif choice == '5':
                update_email(userid)
            elif choice == '6':
                update_phone_no(userid)
            elif choice == '7':
                delete_user(userid)
                print('User deleted')
                print('Exiting...')
                break
            elif choice=='8':
                while True:
                    print("1. Insert a new loan")
                    print("2. Display loans for a given user ID")
                    print("3. Update the amount for a loan")
                    print("4. Update the due date for a loan")
                    print("5. Delete a loan")
                    print("6. Exit")

                    choice1 = input("Enter your choice: ")
                    if choice1 == "1":
                        insert_loan(userid)
                    elif choice1 == "2":
                        select_loans_by_userid(userid)
                    elif choice1 == "3":
                        update_loan_amount(userid)
                    elif choice1 == "4":
                        update_due_date(userid)
                    elif choice1 == "5":
                        delete_loan(userid)
                    elif choice1 == "6":
                        break
                    else:
                        print("Invalid choice. Please try again.")

            elif choice=='9':
                while True:
                    print("1. Insert new insurance")
                    print("2. Delete all insurance")
                    print("3. Display all the insurances taken")
                    print("4. Exit")
                    choice = input("Enter your choice: ")
                    if choice == "1":
                        insert_insurance(userid)
                    elif choice == "2":
                        delete_insurance(userid)
                    elif choice == "3":
                        display_insurance(userid)
                    elif choice == "4":
                        print("Exiting program...")
                        break
                    else:
                        print("Invalid choice. Please try again.")


            elif choice == '10':
                print("Exiting...")
                break
            else:
                print("Invalid choice! Please try again.")
    else:
        print("Invalid user ID or password. Access denied.")

        
elif (ch==2):
    insert_user()
else:
    print("Invalid choice! ")
cnx.close()
