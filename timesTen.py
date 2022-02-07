# timesTen.py
# Author: Victoria Kincaid
# 12/1/20
# Lab 5 Problem 1
# Purpose - The purpose of this program is to take an integer from the user and
# displays the product of that value times 10.

#Create a global variable
number = 0

# Define your main
def main():
    global number
    number = int(input('Please enter an integer to be multiplied by 10: '))
    timesTen()

# Define your timesTen function
def timesTen():
    result = 10 * number
    print(number, 'times 10 is: ', result)

# Call the main function
main()