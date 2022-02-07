# writeSales.py
# Author: Vic Kincaid
# Chapter 6 Practice Problem 3

def main():
    # get number of days
    numDays = int(input("How many days "+ \
                        "do you have sales? "))
    # open a new file sales.txt
    salesFile = open("Sales.txt", "w")
    
    # Get the sales data from the user and write to the file
    for count in range(1, numDays +1):
        # Get the sales amount for one day
        sales= float(input("Enter the sales for the day #" +\
                           str(count) + ": $"))
        # Write sales value to the sales file
        salesFile.write(format(sales, ".2f") + "\n")
        
    # Close the file
    salesFile.close()
    print("Data written to sales.txt")
    
    return

main()