# lineNumbers.py
# Author: Vic Kincaid
# Chapter 6 Homework Problem 1

#define the main
def main():
        # Input a file name from user
        fileName = input("Enter the name of the file: ")
        inFile = open(fileName, "r")
        
        # Get an accumulator
        count = 0
        
        # Get the data from the file to write new information to file
        for line in inFile:
                count = count + 1
                print(str(count) + ": " + line, end = '')
                
        # close the file
        inFile.close()
# close main        
main()