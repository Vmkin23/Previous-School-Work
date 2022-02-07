# Victoria Kincaid
# Midterm Question 27
# tuition.py


#Input

tuition = float(input('Enter the current tuition: $'))
print()

#processing, setting constants

#Output
print('Year\t\tProjected Tuition (per semester)')
print('----------------------------------------------')
for number in range(1, 6):
    tuition = (tuition * .03) + tuition
    print(number, "\t\t",'$',format(tuition,",.2f"))