import risk as r

"""
Test roll_dice
"""
for _ in range(20):
    print(r.roll_dice())

"""
Test random_outcome
"""
print(r.random_outcome(3, 3))
print(r.random_outcome(1, 3))
print(r.random_outcome(2, 1))

"""
Test probability_script
"""
r.probability_script()

