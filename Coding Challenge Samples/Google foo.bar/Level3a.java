import java.math.BigInteger;

/**
 * Fuel Injection Perfection
 =========================

 Commander Lambda has asked for your help to refine the automatic quantum antimatter fuel injection system for her LAMBCHOP doomsday device. It's a great chance for you to get a closer look at the LAMBCHOP - and maybe sneak in a bit of sabotage while you're at it - so you took the job gladly.

 Quantum antimatter fuel comes in small pellets, which is convenient since the many moving parts of the LAMBCHOP each need to be fed fuel one pellet at a time. However, minions dump pellets in bulk into the fuel intake. You need to figure out the most efficient way to sort and shift the pellets down to a single pellet at a time.

 The fuel control mechanisms have three operations:

 1) Add one fuel pellet
 2) Remove one fuel pellet
 3) Divide the entire group of fuel pellets by 2 (due to the destructive energy released when a quantum antimatter pellet is cut in half, the safety controls will only allow this to happen if there is an even number of pellets)

 Write a function called answer(n) which takes a positive integer as a string and returns the minimum number of operations needed to transform the number of pellets to 1. The fuel intake control panel can only display a number up to 309 digits long, so there won't ever be more pellets than you can express in that many digits.

 For example:
 answer(4) returns 2: 4 -> 2 -> 1
 answer(15) returns 5: 15 -> 16 -> 8 -> 4 -> 2 -> 1


 Languages
 =========

 To provide a Python solution, edit solution.py
 To provide a Java solution, edit solution.java

 Test cases
 ==========

 Inputs:
 (string) n = "4"
 Output:
 (int) 2

 Inputs:
 (string) n = "15"
 Output:
 (int) 5

 Use verify [file] to test your solution and see how it does. When you are finished editing your code, use submit [file] to submit your answer. If your solution passes the test cases, it will be removed from your home folder.
 */
public class Level3a {
    public static int answer(String n) {

        // Your code goes here.
        final String SPECIAL_CASE = "11";
        BigInteger input = new BigInteger(n);
        BigInteger binInput = new BigInteger(input.toString(2));
        int operations = 0;
        while (binInput.toString().length() > 1) {
            if (binInput.toString().equals(SPECIAL_CASE)) {
                binInput = new BigInteger(binInput.toString().substring(0, binInput.toString().length() - 1) + "0");
                operations ++;
            } else {
                if (binInput.toString().substring(binInput.toString().length() - 1).equals("0")) {
                    binInput = new BigInteger(binInput.toString().substring(0, binInput.toString().length() - 1));
                    operations ++;
                } else if (binInput.toString().substring(binInput.toString().length() - 2).equals("01")) {
                    binInput = new BigInteger(binInput.toString().substring(0, binInput.toString().length() - 1) + "0");
                    operations ++;
                } else {
                    input = new BigInteger(binInput.toString(), 2);
                    input = input.add(new BigInteger("1"));
                    binInput = new BigInteger(input.toString(2));
                    operations ++;
                }
            }
        }
        return operations;
    }

    public static void main(String[] args) {
        //System.out.println("Answer :" + answer("1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010"));
        System.out.println(answer("15"));
    }
}
