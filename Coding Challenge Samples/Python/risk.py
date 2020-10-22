"""
## 1. Risk

### a.

The board game Risk has simple combat rules: an invading force of
1 to 3 units attacks a defending force of 1 to 3 units. Each
invading unit rolls a 6-sided die, and each defending unit rolls
a 6-sided die. The highest numbered invading die matches to the
highest numbered defending die, then the next highest, etc., as
long as there are two dice to match up. For example, if there are
two attacking dice and one defending die, only one from each side
match up. The side with the higher number on each match up wins,
with the defending die winning the tie.

Write a function that returns a fair, random
`(invading_wins, defending_wins)` for an input
`(invading_count, defending_count)`:

```
def random_outcome(invading_count, defending_count):
  # ...
  return (invading_wins, defending_wins)
```

Example cases are below.

```
random_outcome(2, 1) == (1, 0)
random_outcome(2, 1) == (0, 1)
random_outcome(2, 2) == (1, 1)
random_outcome(2, 2) == (0, 2)
random_outcome(2, 2) == (2, 0)
random_outcome(3, 1) == (1, 0)
random_outcome(3, 1) == (0, 1)
```

### b.

Using this function, write a script that prints a good estimate
for the probabiltiy of the invader winning at least one for each
of the 9 cases of 1..3 invaders and 1..3 defenders. Averaging the
result of 1000 evaluations for the same input is good enough
estimate of the outcome.

Example output is below.

```
with 1 invader and 1 defender, the probably of the invader
winning at least one is about 41%
```
"""
from random import randint


# 1 a.
def random_outcome(invading_count, defending_count):
    """
    Simulates random roll(s) of dice to determine a risk combat encounter
    where there are 1-3 attacking and 1-3 defending
    """
    # handle invalid input
    if invading_count > 3 or defending_count > 3 or invading_count < 1 or defending_count < 1:
        return -1, -1
    invading_wins = 0
    defending_wins = 0
    invading_rolls = []
    defending_rolls = []
    # roll the dice
    for _ in range(invading_count):
        invading_rolls.append(roll_dice())
    for _ in range(defending_count):
        defending_rolls.append((roll_dice()))
    # setup comparison
    invading_rolls.sort(reverse=True)
    defending_rolls.sort(reverse=True)
    comparisons = min(len(invading_rolls), len(defending_rolls))
    for i in range(comparisons):
        if invading_rolls.pop(0) > defending_rolls.pop(0):
            invading_wins += 1
        else:
            defending_wins += 1
    return invading_wins, defending_wins


def roll_dice():
    """
    Returns a random integer from [1,6]
    """
    return randint(1, 6)


# 1 b.
def probability_script():
    """
    Prints probability of invader winning at least one match for each of the 9 cases
    Probability is average over 1000 trials
    """
    # 1 inv, 1 def
    onewin = 0
    for _ in range(1000):
        if random_outcome(1, 1)[0]:
            onewin += 1
    print("with 1 invader and 1 defender, the probably of the invader "
          "winning at least one is about " + '{:.0%}'.format(onewin/1000))
    # 1 inv, 2 def
    onewin = 0
    for _ in range(1000):
        if random_outcome(1, 2)[0]:
            onewin += 1
    print("with 1 invader and 2 defenders, the probably of the invader "
          "winning at least one is about " + '{:.0%}'.format(onewin/1000))
    # 1 inv, 3 def
    onewin = 0
    for _ in range(1000):
        if random_outcome(1, 3)[0]:
            onewin += 1
    print("with 1 invader and 3 defenders, the probably of the invader "
          "winning at least one is about " + '{:.0%}'.format(onewin/1000))
    # 2 inv, 1 def
    onewin = 0
    for _ in range(1000):
        if random_outcome(2, 1)[0]:
            onewin += 1
    print("with 2 invaders and 1 defender, the probably of the invader "
          "winning at least one is about " + '{:.0%}'.format(onewin/1000))
    # 2 inv, 2 def
    onewin = 0
    for _ in range(1000):
        if random_outcome(2, 2)[0]:
            onewin += 1
    print("with 2 invaders and 2 defenders, the probably of the invader "
          "winning at least one is about " + '{:.0%}'.format(onewin/1000))
    # 2 inv, 3 def
    onewin = 0
    for _ in range(1000):
        if random_outcome(2, 3)[0]:
            onewin += 1
    print("with 2 invaders and 3 defenders, the probably of the invader "
          "winning at least one is about " + '{:.0%}'.format(onewin/1000))
    # 3 inv, 1 def
    onewin = 0
    for _ in range(1000):
        if random_outcome(3, 1)[0]:
            onewin += 1
    print("with 3 invaders and 1 defender, the probably of the invader "
          "winning at least one is about " + '{:.0%}'.format(onewin/1000))
    # 3 inv, 2 def
    onewin = 0
    for _ in range(1000):
        if random_outcome(3, 2)[0]:
            onewin += 1
    print("with 3 invaders and 2 defenders, the probably of the invader "
          "winning at least one is about " + '{:.0%}'.format(onewin/1000))
    # 3 inv, 3 def
    onewin = 0
    for _ in range(1000):
        if random_outcome(3, 3)[0]:
            onewin += 1
    print("with 3 invaders and 3 defenders, the probably of the invader "
          "winning at least one is about " + '{:.0%}'.format(onewin/1000))








