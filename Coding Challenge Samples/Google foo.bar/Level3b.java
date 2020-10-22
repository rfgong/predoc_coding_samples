import java.util.ArrayList;
import java.util.Arrays;

/**
 * Doomsday Fuel
 =============

 Making fuel for the LAMBCHOP's reactor core is a tricky process because of the exotic matter involved. It starts as raw ore, then during processing, begins randomly changing between forms, eventually reaching a stable form. There may be multiple stable forms that a sample could ultimately reach, not all of which are useful as fuel.

 Commander Lambda has tasked you to help the scientists increase fuel creation efficiency by predicting the end state of a given ore sample. You have carefully studied the different structures that the ore can take and which transitions it undergoes. It appears that, while random, the probability of each structure transforming is fixed. That is, each time the ore is in 1 state, it has the same probabilities of entering the next state (which might be the same state).  You have recorded the observed transitions in a matrix. The others in the lab have hypothesized more exotic forms that the ore can become, but you haven't seen all of them.

 Write a function answer(m) that takes an array of array of nonnegative ints representing how many times that state has gone to the next state and return an array of ints for each terminal state giving the exact probabilities of each terminal state, represented as the numerator for each state, then the denominator for all of them at the end and in simplest form. The matrix is at most 10 by 10. It is guaranteed that no matter which state the ore is in, there is a path from that state to a terminal state. That is, the processing will always eventually end in a stable state. The ore starts in state 0. The denominator will fit within a signed 32-bit integer during the calculation, as long as the fraction is simplified regularly.

 For example, consider the matrix m:
 [
 [0,1,0,0,0,1],  # s0, the initial state, goes to s1 and s5 with equal probability
 [4,0,0,3,2,0],  # s1 can become s0, s3, or s4, but with different probabilities
 [0,0,0,0,0,0],  # s2 is terminal, and unreachable (never observed in practice)
 [0,0,0,0,0,0],  # s3 is terminal
 [0,0,0,0,0,0],  # s4 is terminal
 [0,0,0,0,0,0],  # s5 is terminal
 ]
 So, we can consider different paths to terminal states, such as:
 s0 -> s1 -> s3
 s0 -> s1 -> s0 -> s1 -> s0 -> s1 -> s4
 s0 -> s1 -> s0 -> s5
 Tracing the probabilities of each, we find that
 s2 has probability 0
 s3 has probability 3/14
 s4 has probability 1/7
 s5 has probability 9/14
 So, putting that together, and making a common denominator, gives an answer in the form of
 [s2.numerator, s3.numerator, s4.numerator, s5.numerator, denominator] which is
 [0, 3, 2, 9, 14].

 Languages
 =========

 To provide a Python solution, edit solution.py
 To provide a Java solution, edit solution.java

 Test cases
 ==========

 Inputs:
 (int) m = [[0, 2, 1, 0, 0], [0, 0, 0, 3, 4], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]
 Output:
 (int list) [7, 6, 8, 21]

 Inputs:
 (int) m = [[0, 1, 0, 0, 0, 1], [4, 0, 0, 3, 2, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
 Output:
 (int list) [0, 3, 2, 9, 14]

 Use verify [file] to test your solution and see how it does. When you are finished editing your code, use submit [file] to submit your answer. If your solution passes the test cases, it will be removed from your home folder.
 */
public class Level3b {

    public static int[] answer(int[][] m) {

        // Your code goes here.
        ArrayList<Integer> rowSums = new ArrayList<>();
        ArrayList<Integer> tStates = new ArrayList<>();
        ArrayList<Integer> nStates = new ArrayList<>();

        // Identifying terminal states
        for (int row = 0; row < m.length; row++) {
            int rowSum = 0;
            boolean nonZeroTerminal = true;
            for (int col = 0; col < m[row].length; col++) {
                if ((col != row) && (m[row][col] != 0)) {
                    nonZeroTerminal = false;
                }
                rowSum += m[row][col];
            }
            rowSums.add(rowSum);
            if (rowSum == 0) {
                tStates.add(row);
            } else if (nonZeroTerminal) {
                tStates.add(row);
            } else {
                nStates.add(row);
            }
        }
        // Test
        // System.out.println(Arrays.deepToString(m));

        // Create probability matrix of m
        Rational[][] probM = new Rational[m.length][m[0].length];
        for (int row = 0; row < probM.length; row++) {
            for (int col = 0; col < probM[row].length; col++) {
                if (rowSums.get(row) != 0) {
                    probM[row][col] = new Rational(m[row][col], rowSums.get(row));
                } else {
                    if (col == row) {
                        probM[row][col] = new Rational(1, 1);
                    } else {
                        probM[row][col] = new Rational(0,1);
                    }
                }
            }
        }
        // Test
        System.out.println("M :");
        System.out.println(Arrays.deepToString(probM));

        // So is terminal
        if (probM[0][0].compareTo(new Rational(1, 1)) == 0) {
            int[] solution = new int[tStates.size() + 1];
            solution[0] = 1;
            solution[solution.length - 1] = 1;
            return solution;
        }

        // Create matrix R
        Rational[][] R = new Rational[m.length - tStates.size()][tStates.size()];
        for (int row = 0; row < R.length; row++) {
            for (int col = 0; col < R[row].length; col++) {
                R[row][col] = probM[nStates.get(row)][tStates.get(col)];
            }
        }
        // Test
        System.out.println("R :");
        System.out.println(Arrays.deepToString(R));

        // Create matrix Q
        Rational[][] Q = new Rational[m.length - tStates.size()][m[0].length - tStates.size()];
        for (int row = 0; row < Q.length; row++) {
            for (int col = 0; col < Q[row].length; col++) {
                Q[row][col] = probM[nStates.get(row)][nStates.get(col)];
            }
        }
        // Test
        System.out.println("Q :");
        System.out.println(Arrays.deepToString(Q));

        // Create matrix I - Q
        Rational[][] I_Q = new Rational[m.length - tStates.size()][m[0].length - tStates.size()];
        for (int row = 0; row < I_Q.length; row++) {
            for (int col = 0; col < I_Q[row].length; col++) {
                if (row == col){
                    I_Q[row][col] = new Rational(1,1).minus(probM[nStates.get(row)][nStates.get(col)]);
                } else {
                    I_Q[row][col] = probM[nStates.get(row)][nStates.get(col)].negate();
                }
            }
        }
        // Test
        System.out.println("I-Q :");
        System.out.println(Arrays.deepToString(I_Q));

        // Invert I - Q creating F, and F starts as identity matrix
        Rational[][] F = new Rational[I_Q.length][I_Q[0].length]; // May result in out of bounds
        for (int row = 0; row < F.length; row++) {
            for (int col = 0; col < F[row].length; col++) {
                if (col == row) {
                    F[row][col] = new Rational(1, 1);
                } else {
                    F[row][col] = new Rational(0,1);
                }
            }
        }
        // Test
        System.out.println("F :");
        System.out.println(Arrays.deepToString(F));

        int operations = I_Q[0].length;
        while (operations > 0) {
            int currentPivot = I_Q.length - operations;
            // Ensure nonzero pivot
            if (I_Q[currentPivot][currentPivot].numerator() == 0) {
                // Find new pivot from below it
                for (int row = currentPivot + 1; row < I_Q.length; row++) {
                    if (I_Q[row][currentPivot].numerator() != 0) {
                        // Swap rows in I_Q and F
                        Rational[] tempI_Q = I_Q[currentPivot];
                        I_Q[currentPivot] = I_Q[row];
                        I_Q[row] = tempI_Q;
                        Rational[] tempF = F[currentPivot];
                        F[currentPivot] = F[row];
                        F[row] = tempF;
                        break;
                    }
                }
            }
            // Ensure pivot 1 by scaling if needed
            if (I_Q[currentPivot][currentPivot].compareTo(new Rational(1,1)) != 0) {
                Rational divisor = I_Q[currentPivot][currentPivot];
                for (int col = 0; col < I_Q[currentPivot].length; col ++) {
                    I_Q[currentPivot][col] = I_Q[currentPivot][col].divided(divisor);
                    F[currentPivot][col] = F[currentPivot][col].divided(divisor);
                }
            }

            // Zero out all other columns
            for (int row = 0; row < I_Q.length; row++) {
                if (row == currentPivot) {
                    continue;
                } else if (I_Q[row][currentPivot].numerator() != 0) {
                    Rational scalar = I_Q[row][currentPivot];
                    for (int col = 0; col < I_Q[row].length; col ++) {
                        I_Q[row][col] = I_Q[row][col].minus(I_Q[currentPivot][col].times(scalar));
                        F[row][col] = F[row][col].minus(F[currentPivot][col].times(scalar));
                    }
                }
            }
            operations --;
        }
        // Test
        System.out.println(Arrays.deepToString(F));

        // F * R read off first row
        Rational[] SoRow = new Rational[R[0].length];
        for (int col = 0; col < SoRow.length; col++) {
            Rational colVal = new Rational(0,1);
            for (int row = 0; row < R.length; row++) {
                colVal = colVal.plus(F[0][row].times(R[row][col]));
            }
            SoRow[col] = colVal;
        }

        // Test
        System.out.println(Arrays.deepToString(SoRow));

        // Find the least common multiple of denominators
        int denom = 1;
        for (Rational r : SoRow) {
            denom = Rational.lcm(denom, r.denominator());
        }

        // Find scaled numerators
        for (int col = 0; col < SoRow.length; col++) {
            SoRow[col] = SoRow[col].times(new Rational(denom, 1));
        }

        // Put it all together
        int[] solution = new int[SoRow.length + 1];
        for (int col = 0; col < SoRow.length; col++) {
            solution[col] = SoRow[col].numerator();
        }
        solution[solution.length - 1] = denom;

        return solution;
    }

    /**
     * Modified from https://introcs.cs.princeton.edu/java/92symbolic/Rational.java.html
     * Robert Sedgewick and Kevin Wayne
     *
     * Used so I don't have to reinvent the wheel
     */
    private static class Rational implements Comparable<Rational>{
        private static Rational zero = new Rational(0, 1);

        private int num;   // the numerator
        private int den;   // the denominator

        // create and initialize a new Rational object
        public Rational(int numerator, int denominator) {

            if (denominator == 0) {
                throw new ArithmeticException("denominator is zero");
            }

            // reduce fraction
            int g = gcd(numerator, denominator);
            num = numerator   / g;
            den = denominator / g;

            // needed only for negative numbers
            if (den < 0) { den = -den; num = -num; }
        }

        // return the numerator and denominator of (this)
        public int numerator()   { return num; }
        public int denominator() { return den; }

        // return string representation of (this)
        public String toString() {
            if (den == 1) return num + "";
            else          return num + "/" + den;
        }

        // return { -1, 0, +1 } if a < b, a = b, or a > b
        public int compareTo(Rational b) {
            Rational a = this;
            int lhs = a.num * b.den;
            int rhs = a.den * b.num;
            if (lhs < rhs) return -1;
            if (lhs > rhs) return +1;
            return 0;
        }

        // is this Rational object equal to y?
        public boolean equals(Object y) {
            if (y == null) return false;
            if (y.getClass() != this.getClass()) return false;
            Rational b = (Rational) y;
            return compareTo(b) == 0;
        }

        // return gcd(|m|, |n|)
        private static int gcd(int m, int n) {
            if (m < 0) m = -m;
            if (n < 0) n = -n;
            if (0 == n) return m;
            else return gcd(n, m % n);
        }

        // return lcm(|m|, |n|)
        private static int lcm(int m, int n) {
            if (m < 0) m = -m;
            if (n < 0) n = -n;
            return m * (n / gcd(m, n));    // parentheses important to avoid overflow
        }

        // return a * b, staving off overflow as much as possible by cross-cancellation
        public Rational times(Rational b) {
            Rational a = this;

            // reduce p1/q2 and p2/q1, then multiply, where a = p1/q1 and b = p2/q2
            Rational c = new Rational(a.num, b.den);
            Rational d = new Rational(b.num, a.den);
            return new Rational(c.num * d.num, c.den * d.den);
        }

        // return a + b, staving off overflow
        public Rational plus(Rational b) {
            Rational a = this;

            // special cases
            if (a.compareTo(zero) == 0) return b;
            if (b.compareTo(zero) == 0) return a;

            // Find gcd of numerators and denominators
            int f = gcd(a.num, b.num);
            int g = gcd(a.den, b.den);

            // add cross-product terms for numerator
            Rational s = new Rational((a.num / f) * (b.den / g) + (b.num / f) * (a.den / g),
                    lcm(a.den, b.den));

            // multiply back in
            s.num *= f;
            return s;
        }

        // return -a
        public Rational negate() {
            return new Rational(-num, den);
        }

        // return a - b
        public Rational minus(Rational b) {
            Rational a = this;
            return a.plus(b.negate());
        }


        public Rational reciprocal() { return new Rational(den, num);  }

        // return a / b
        public Rational divided(Rational b) {
            Rational a = this;
            return a.times(b.reciprocal());
        }
    }

    public static void main(String[] args) {
        int[][] test1 = {{0, 2000000, 1000000, 0, 0}, {0, 0, 0, 3000000, 4000000}, {0, 0, 12312312, 0, 0}, {0, 0, 0, 90321, 0}, {0, 0, 0, 0, 9794214}};
        int[][] test2 = {{0, 1, 0, 0, 0, 1}, {4, 0, 0, 3, 2, 0}, {0, 0, Integer.MAX_VALUE, 0, 0, 0}, {0, 0, 0, Integer.MAX_VALUE, 0, 0}, {0, 0, 0, 0, Integer.MAX_VALUE, 0}, {0, 0, 0, 0, 0, Integer.MAX_VALUE}};
        int[][] test3 = {{21312312,0},{0,0}};
        int[][] test4 = {{1,0,0},{0,1,0},{0,0,0}};
        int[][] test5 = {{0,0,1},{0,28,0},{0,0,29}};
        int[][] test6 = {{Integer.MAX_VALUE,0},{0,Integer.MAX_VALUE}};
        int[][] test7 = {{0, 200000000, 100000000, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, 300000000, 400000000, 0, 0, 0, 0, 0},{0, 0, Integer.MAX_VALUE, 0, 0, 0, 0, 0, 0, 0},{0, 0, 0, Integer.MAX_VALUE, 0, 0, 0, 0, 0, 0},{0, 0, 0, 0, Integer.MAX_VALUE, 0, 0, 0, 0, 0},{0, 0, 0, 0, 0, Integer.MAX_VALUE, 0, 0, 0, 0},{0, 0, 0, 0, 0, 0, Integer.MAX_VALUE, 0, 0, 0},{0, 0, 0, 0, 0, 0, 0, Integer.MAX_VALUE, 0, 0},{0, 0, 0, 0, 0, 0, 0, 0, Integer.MAX_VALUE, 0},{0, 0, 0, 0, 0, 0, 0, 0, 0, Integer.MAX_VALUE}};
        System.out.println(Arrays.toString(answer(test7)));
        /**
         */
    }
}
