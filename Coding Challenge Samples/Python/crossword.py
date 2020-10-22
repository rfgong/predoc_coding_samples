"""
## 3. Crossword

A crossword puzzle is a grid with blank slots, starting at some initial
(x, y) and going either across or down, for some length of squares. The
blank slots need to be filled with words from a vocabulary, where one
character goes into each square. The blank slots may overlap requiring
that the words in each slot share the same character at that point.

Given a vocabulary as a list of strings,

```
vocab = ['word', 'another', 'longer', ...]
```

and a list of blank slots,

```
ACROSS = 0
DOWN = 1
blanks = [(start_x, start_y, direction, length), ...]
```

Write a function that returns any solution to the crossword, or `None`
if no solution exists. The solution should be a list of
`[(start_x, start_y, direction, word_from_vocab_that_goes_here), ...]`.


Example outputs are below.

```
solve_crossword(vocab=['the', 'begin'],
  blanks=[
    (0, 1, ACROSS, 3),
    (2, 0, DOWN, 5)
  ]) == [
    (0, 1, ACROSS, 'the'),
    (2, 0, DOWN, 'begin')
  ]
solve_crossword(vocab=['next', 'time', 'expect', 'electric'],
  blanks=[
    (0, 0, ACROSS, 4),
    (1, 0, DOWN, 6),
    (3, 0, DOWN, 4),
    (1, 3, ACROSS, 8)
  ]) == [
    (0, 0, ACROSS, 'next'),
    (1, 0, DOWN, 'expect'),
    (3, 0, DOWN, 'time'),
    (1, 3, ACROSS, 'electric')
  ]
solve_crossword(vocab=['one', 'two', 'three'],
  blanks=[
    (0, 0, ACROSS, 4)
  ]) == None
```
"""
from random import randint


# 3.
def solve_crossword(vocab, blanks):
    """
    In this implementation I'll use local search with iterative improvement, using the min-conflicts heuristic.
    Aside from a narrow critical ratio, this algorithm is extremely fast
    Another possible approach would be backtracking search with arc consistency checks, and assignment considering
     minimum remaining values for choosing a blank to assign to and using the least constraining word assignment.
    """
    # this value can be freely adjusted
    attempts = len(blanks)**2
    # attempts to solve puzzle with random restart if a "failure" occurs
    # this is one way to deal getting stuck at a local maximum or plateau when hill climbing
    for i in range(attempts):
        # print("Attempt " + str(i) + ": ")
        solution = solve_crossword_helper(vocab, blanks)
        if solution:
            return solution
    return None


def solve_crossword_helper(vocab, blanks):
    """
    vocab: vocabulary as a list of strings
    blanks: list of (start_x, start_y, direction, length)
    It is possible to add "annealing" to this function to get out of a local maximum
    This would be a continuously decreasing probability a that a suboptimal assignment is made intentionally
    """
    # invalid input
    if not vocab or not blanks or not len(vocab) or not len(blanks):
        return None
    # dictionary that maps length of word to list of words of that length
    vocab_dict = generate_vocab_dict(vocab)
    # dictionary that maps word to the number of times it's being used
    vocab_used = {}
    # list that holds all blanks
    blanks_list = []
    # dictionary that maps square (x, y) to a list of blanks that include it
    overlapping = {}
    for i in range(len(blanks)):
        # create Blank object
        blank = Blank(blanks[i], i)
        blanks_list.append(blank)
        # assign a random word of matching length to blank, without repeats
        if blank.length not in vocab_dict:
            return None
        possible_words = vocab_dict[blank.length]
        if not possible_words:
            return None
        random_index = randint(0, len(possible_words) - 1)
        blank.assign_word(possible_words.pop(random_index))
        # update word usage dictionary
        if blank.word in vocab_used:
            vocab_used[blank.word] += 1
        else:
            vocab_used[blank.word] = 1
        # updated overlapping with squares from blank
        for square in blank.squares:
            if square in overlapping:
                overlapping[square].append(blank)
            else:
                overlapping[square] = [blank]
    # keep actual overlaps
    clean_overlapping(overlapping)
    # restore dictionary that maps length of word to list of words of that length
    vocab_dict = generate_vocab_dict(vocab)
    # if we don't improve in many consecutive assignments return None
    # this value can be freely adjusted
    no_improve = len(blanks) * 5
    while no_improve > 0:
        # dictionary maps blank to the number of conflicts it causes
        conflicts = check_conflicts(overlapping, vocab_used)
        # compute sum conflicts, and get conflicted blanks
        sum_conflicted_tuple = sum_conflicts(conflicts, blanks_list)
        # if no conflicts return
        if sum_conflicted_tuple[0] == 0:
            return [(blank.start_x, blank.start_y, blank.direction, blank.word) for blank in blanks_list]
        # randomly choose a conflicted blank to improve
        conflicted_blanks = sum_conflicted_tuple[1]
        random_index = randint(0, len(conflicted_blanks) - 1)
        # determine words that result in min total conflicts when assigned to blank
        reassign_blank = conflicted_blanks[random_index]
        possible_words = vocab_dict[reassign_blank.length]
        old_conflicts = sum_conflicted_tuple[0]
        min_conflicts = float('Inf')
        min_conflicts_words = []
        for pos_word in possible_words:
            # decrement use count of current word
            vocab_used[reassign_blank.word] += -1
            reassign_blank.assign_word(pos_word)  # possible for same word or word reuse to climb
            # update word usage dictionary
            if reassign_blank.word in vocab_used:
                vocab_used[reassign_blank.word] += 1
            else:
                vocab_used[reassign_blank.word] = 1
            # compute conflicts and update findings
            conflicts = check_conflicts(overlapping, vocab_used)
            sum_conflicted_tuple = sum_conflicts(conflicts, blanks_list)
            if sum_conflicted_tuple[0] < min_conflicts:
                min_conflicts = sum_conflicted_tuple[0]
                min_conflicts_words = [pos_word]
            elif sum_conflicted_tuple[0] == min_conflicts:
                min_conflicts_words.append(pos_word)
        # if no improvement has been made to total conflicts using any assignment to blank
        if old_conflicts - min_conflicts <= 0:
            no_improve += -1
        else:
            # reset no_improve
            # no_improve = len(blanks) * 5
            no_improve += 1
        # of the min_conflicts_words choose one to randomly replace the current word
        random_index = randint(0, len(min_conflicts_words) - 1)
        vocab_used[reassign_blank.word] += -1
        reassign_blank.assign_word(min_conflicts_words[random_index])
        vocab_used[reassign_blank.word] += 1
    # no improvement counter is zero
    return None


def generate_vocab_dict(vocab):
    """
    Creates dictionary that maps length of word to list of words of that length
    """
    v_dict = {}
    for word in vocab:
        if len(word) in v_dict:
            v_dict[len(word)].append(word)
        else:
            v_dict[len(word)] = [word]
    return v_dict


def clean_overlapping(overlapping):
    """
    Mutative removal of squares that correspond to only one blank (since we only want to save overlaps)
    """
    remove = []
    for square in overlapping:
        if len(overlapping[square]) == 1:
            remove.append(square)
    for square in remove:
        overlapping.pop(square)
    return overlapping


def check_conflicts(overlapping, vocab_used):
    """
    Returns a dictionary mapping blank number (index) to the number of conflicts the blank's word assignment cause
    """
    conflicts = {}
    for square in overlapping:
        overlapped_blanks = overlapping.get(square)
        # if word at blank is used multiple times add a conflict for the corresponding blank
        for blank in overlapped_blanks:
            if blank.index not in conflicts:
                conflicts[blank.index] = vocab_used[blank.word] - 1
        # examine for letter conflict at the overlapped square
        # assume there are no nested words so there can only be two overlapping blanks at a square
        blankA = overlapped_blanks[0]
        blankB = overlapped_blanks[1]
        # word letters in blank are aligned with it's spanning squares
        blankA_letter = blankA.word[blankA.squares.index(square)]
        blankB_letter = blankB.word[blankB.squares.index(square)]
        if blankA_letter != blankB_letter:
            # not the same so add conflicts
            conflicts[blankA.index] += 1
            conflicts[blankB.index] += 1
    return conflicts


def sum_conflicts(conflicts, blanks_list):
    """
    Returns a tuple (sum of all conflicts, list of blanks with conflicts)
    """
    sum_con = 0
    conflict_blanks = []
    for b in conflicts:
        if conflicts[b]:
            conflict_blanks.append(blanks_list[b])
        sum_con += conflicts[b]
    return sum_con, conflict_blanks


class Blank:
    """
    Represents a blank in puzzle
    """
    def __init__(self, tuple, index):
        self.index = index
        self.start_x = tuple[0]
        self.start_y = tuple[1]
        self.direction = tuple[2]
        self.length = tuple[3]
        self.squares = self.spanning_squares()
        # word assigned to blank
        self.word = None

    def assign_word(self, word):
        self.word = word

    def spanning_squares(self):
        """
        Returns a list of tuples (x, y) that the blank spans
        """
        spanning = []
        for i in range(self.length):
            # Assume ACROSS and DOWN are the only valid directions
            if self.direction == "ACROSS":
                spanning.append((self.start_x + i, self.start_y))
            else:
                spanning.append((self.start_x, self.start_y + i))
        return spanning

    def __repr__(self):
        return str((self.start_x, self.start_y, self.direction, self.index, self.word))


