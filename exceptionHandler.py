# execptionHandler.py
# Author: Vic Kincaid
# Chapter 6 Homework Problem 2

# define main
def main():
    
    #initialize an accumulator
    total = 0.0
    count = 0
    
    try:
        # Open numbers.txt file
        inFile = open("numbers.txt", "r")
        
        # read the values from the file and average them
        for line in inFile:
            count = count + 1
            amount = float(line)
            total = amount + total
            avg = total/count
        # Close the file
        inFile.close()
        
    # except Exception as err  #this handles all types of exceptions
    except IOError:
        print("An error occurred while trying to read the file.")
    except ValueError:
        print("Non-numeric data found in the file.")
    else:
        print("Average: ", avg)
    
    return
# close main
main()
