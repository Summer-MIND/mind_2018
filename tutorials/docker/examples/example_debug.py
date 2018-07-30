from examples.helpers import add_it

print('Hello, CDL!')  # Python 3.x doesn't support
print('Hope you like the tutorial ')  # Python 3.x does support this!

# example for loop for debugging

for i in range(5):
    print('i = ', i) # this formatting will fail with Python 3.x

    # walk through add_it function in separate script
    print(f'i + 4 = {add_it(i)}') # this formatting will fail with Python 2.7


# it even catches typos!
print('Thats all folks')

print("That's all folks")