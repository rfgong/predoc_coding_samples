import traffic as t

"""
Test run_cars
"""
print("Test 1:")
cars = [(0, 0, 2), (0, 1, 1)]
print(t.run_cars(cars, 1))
print(t.run_cars(cars, 2))
print(t.run_cars(cars, 3))

print("Test 2:")
cars = [(0, 0, 5), (1, 0, 2)]
print(t.run_cars(cars, 1))
print(t.run_cars(cars, 2))
print(t.run_cars(cars, 3))

print("Test 3:")
cars = t.generate_random_cars(4, 2)
print(t.run_cars(cars, 1))
print(t.run_cars(cars, 2))
print(t.run_cars(cars, 3))

print("Test 4:")
cars = t.generate_random_cars(5, 2)
print(t.run_cars(cars, 1))
print(t.run_cars(cars, 2))
print(t.run_cars(cars, 3))
print(t.run_cars(cars, 4))
print(t.run_cars(cars, 5))
print(t.run_cars(cars, 6))