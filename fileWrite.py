# fileWrite.py
# Author: Vic Kincaid
# Chapter 6 Practice Problem 1

def main():
    #create file object and open in write mode
    outFile = open("philosophers.txt","w")
   
    # write the names of three philosophers to outFile
    outFile.write("John Locke\n")
    outFile.write("Plato\n")
    outFile.write("Epictetus\n")
    
    #close the file
    outFile.close()
    
    
    return
       
    
#Call main() to start program    
main()    