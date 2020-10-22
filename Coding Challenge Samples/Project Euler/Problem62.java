/**
The cube, 41063625 (345^3), can be permuted to produce two other cubes: 56623104 (384^3) and 66430125 (405^3). 
In fact, 41063625 is the smallest cube which has exactly three permutations of its digits which are also cube.

Find the smallest cube for which exactly five permutations of its digits are cube.
*/
import java.math.BigInteger;
import java.util.TreeMap;
import java.util.TreeSet;

public class Problem62 {

    /**
     * Takes number and arranges digits in ascending order
     * @param num
     * @return
     */
    private static String digStringHash(String num){
        String ordered = "";
        TreeMap<Character, Integer> digits = new TreeMap<>();
        for (char c: num.toCharArray()) {
            if (digits.containsKey(c)) {
                digits.put(c, digits.get(c) + 1);
            } else {
                digits.put(c, 1);
            }
        }
        for (Character c: digits.keySet()) {
            for (int i = 0; i < digits.get(c); i++) {
                ordered += c;
            }
        }
        return ordered;
    }

    public static void cubicRunner(){

        TreeMap<String, Integer> digSeqToCount = new TreeMap<>();
        TreeMap<String, String> digSeqToMin = new TreeMap<>();
        TreeSet<BigInteger> fiveCube = new TreeSet<>();

        for (int i = 4; i < 1000000; i++) {
            BigInteger cubed = new BigInteger(Integer.toString(i));
            cubed = cubed.pow(3);
            String key = digStringHash(cubed.toString());
            if (!digSeqToMin.containsKey(key)) {
                digSeqToMin.put(key, cubed.toString());
                digSeqToCount.put(key, 1);
            } else {
                digSeqToCount.put(key, digSeqToCount.get(key) + 1);
                if (digSeqToCount.get(key) >= 5) {
                    fiveCube.add(new BigInteger(digSeqToMin.get(key)));
                }
            }
        }
        for (BigInteger b: fiveCube) {
            System.out.println(b);
            return;
        }
    }

    public static void main(String[] args) {
        cubicRunner();
    }
}
