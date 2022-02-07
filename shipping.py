# Victoria Kincaid
# Midterm Question 26
# shipping.py

# Named Constants
rateOne = 1.50
rateTwo = 3.00
rateThree = 4.00
rateFour = 4.75

#Input

weight = float(input('Enter the weight of the packages in pounds: '))
print()

#Processing

if weight > 10:
    charge = weight*rateFour
elif weight > 6:
    charge = weight*rateThree
elif weight > 2:
    charge = weight*rateTwo
elif weight <=2:
    charge = weight*rateOne
    
#Output
print("Shipping Charge: $"+format(charge,".2f"))

    



