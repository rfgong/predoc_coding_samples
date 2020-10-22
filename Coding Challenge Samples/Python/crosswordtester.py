import crossword as c

"""
Test generate_vocab_dict
print(c.generate_vocab_dict(['the', 'begin']))
print(c.generate_vocab_dict(['next', 'time', 'expect', 'electric']))
"""


"""
Test Blank.squares
blank = c.Blank((0, 1, "ACROSS", 3), 0)
print(blank.squares)
blank = c.Blank((2, 0, "DOWN", 5), 0)
print(blank.squares)
"""


"""
Test solve_crossword
"""
print(c.solve_crossword(['the', 'begin'], [(0, 1, "ACROSS", 3), (2, 0, "DOWN", 5)]))
print(c.solve_crossword(['next', 'time', 'expect', 'electric'], [(0, 0, "ACROSS", 4), (1, 0, "DOWN", 6), (3, 0, "DOWN", 4), (1, 3, "ACROSS", 8)]))
print(c.solve_crossword(['one', 'two', 'three'], [(0, 0, "ACROSS", 4)]))


"""
# online test case: http://www.printactivities.com/Crosswords/9x9-Easy-Crosswords/9x9Crossword-Grid1-0001-Soln.html#.XIq_BRNKjUo
"""
words = ['site', 'sub', 'tee', 'cans', 'ali', 'see', 'bees', 'ended', 'sassy', 'stand', 'side', 'drive', 'ant', 'idas', 'axis', 'sun', 'idly', 'ive', 'los', 'deer', 'eve', 'red', 'east', 'read']
blanks=[
    (0, 0, 'ACROSS', 4),
    (0, 0, 'DOWN', 3),
    (2, 0, 'DOWN', 3),
    (5, 0, 'ACROSS', 4),
    (6, 0, 'DOWN', 3),
    (8, 0, 'DOWN', 3),
    (0, 2, 'ACROSS', 4),
    (1, 2, 'DOWN', 5),
    (3, 2, 'DOWN', 5),
    (5, 2, 'ACROSS', 4),
    (5, 2, 'DOWN', 5),
    (7, 2, 'DOWN', 5),
    (3, 3, 'ACROSS', 3),
    (0, 4, 'ACROSS', 4),
    (5, 4, 'ACROSS', 4),
    (3, 5, 'ACROSS', 3),
    (0, 6, 'ACROSS', 4),
    (0, 6, 'DOWN', 3),
    (2, 6, 'DOWN', 3),
    (5, 6, 'ACROSS', 4),
    (6, 6, 'DOWN', 3),
    (8, 6, 'DOWN', 3),
    (0, 8, 'ACROSS', 4),
    (5, 8, 'ACROSS', 4)
]
print(c.solve_crossword(words, blanks))


"""
# online test case: https://is3-ssl.mzstatic.com/image/thumb/Purple69/v4/a2/ed/0e/a2ed0e58-743e-6772-b7f9-e6c4e81df9d8/pr_source.jpg/750x750bb.jpeg
"""
words = ['scam', 'tone', 'arts', 'bees', 'stab', 'core', 'ante', 'mess']
blanks = [(0, 0, 'ACROSS', 4), (0, 0, 'DOWN', 4), (0, 1, 'ACROSS', 4), (1, 0, 'DOWN', 4), (0, 2, 'ACROSS', 4), (2, 0, 'DOWN', 4), (0, 3, 'ACROSS', 4), (3, 0, 'DOWN', 4)]
print(c.solve_crossword(words, blanks))





