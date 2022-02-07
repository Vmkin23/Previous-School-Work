# vowels.py
# Author: Victoria Kincaid
# 12/2/20
# Lab 5 Problem 2
# Purpose - The purpose of this program is to determine the amount of vowels in
# a given string.

# Create a global variable
vowels = 0

# Define Main
def main():
    print('This program will calculate the number of vowels in a string of characters.')
    global vowels
    vowels = str(input('Enter a string: '))
    print()
    countVowels()

# Define the countVowels function, using your global
def countVowels():
    count = 0
    global vowels
    for c in vowels:
        if c == 'a':
            count = count + 1
        elif c == 'e':
            count = count + 1
        elif c == 'i':
            count = count + 1
        elif c == 'o':
            count = count + 1
        elif c == 'u':
            count = count + 1
        # I considered making 'y' count as .5 but reasoned that being pendantic gets me nowhere, also in the example 'y' didn't count
        
    print('The string contains', count, 'vowels.')


# Call the main function    
main()