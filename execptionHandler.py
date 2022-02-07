# execptionHandler.py
# Author: Vic Kincaid
# Chapter 6 Practice Problem 4

def main():
    try:
        # Input a file name from user
        fileName = input("Enter the name of the file to open: ")
        inFile = open(fileName, "r")
    # except Exception as err  #this handles all types of exceptions
    except IOError as err:
        print(err)
    except ValueError as err:
        print(err)
    else:
        print("File opened successfully")
    
    return
main()