# Victoria Kincaid
# Midterm Question 28
# cashier.py

# Constant Value
SENTINEL = -1

# Creating a total accumulator value
subtotal = 0

# Input
value = float(input("Please enter the price of the first item: $"))

while value != SENTINEL:
    while value <=0:
        print("Invalid input")
        value = float(input("Enter the price of the next item or -1 when finished: $"))    
    
    subtotal = subtotal + value
    
    value = float(input("Enter the price of the next item or -1 when finished: $"))
    
    tax = subtotal * .07
    total = subtotal + tax
    # average = subtotal / value
    
 
print() 
# output
print("Subtotal: $",format(subtotal,'.2f'))
print("Tax: $",format(tax, '.2f'))
print("Total: $",format(total, '.2f'))
# print("Avg. price per item: $",format(average, '.2f'))

#end

# I know I am going to get this either fully wrong or partially wrong due
# to the average but could you go over how to do an average on the accumulator?
# I see chapter 4 program 4-17 for the average on an accumulator, but it simply
# asks at the beginning how many tests there are to average from in the beginning
# and this didn't have a prompt, so I've been stumped on this one. 