# stripNewLine.py
# Author: Vic Kincaid
# Chapter 6 Practice Problem 2

def main():
    #Open file philosophers.txt for reading
    inFile = open("philosophers.txt","r")
    
    # Read three lines from file
    lineOne = inFile.readline()
    lineTwo = inFile.readline()
    lineThree = inFile.readline()
    
    #close file
    inFile.close()    
    
    # strip \n from each line
    lineOne = lineOne.rstrip("\n")
    lineTwo = lineTwo.rstrip("\n")
    lineThree = lineThree.rstrip("\n")
    
    #Print the three lines
    print(lineOne)
    print(lineTwo)
    print(lineThree)

    
    
    return
main()