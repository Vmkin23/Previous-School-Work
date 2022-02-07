# leapYears.py
# Author: Victoria Kincaid
# 12/3/20
# Lab 5 Problem 3
# Purpose - The purpose of this program is to determine if a given year is a 
# leap year.

#Define your main function
def main():
     year = int(input('Please enter a year and I will determine if it is a leap year: '))
     print()
     isLeapYear(year)

#Define your isLeapYear function   
def isLeapYear(year):
     for number in range(1) :
          if year%400 == 0:
               result = True
          elif year%100 == 0:
               result = False
          elif year%4 == 0:
               result = True
          else:
               result = False
          print(year, 'is a leap year: ', result)  

# Call the main function
main()
