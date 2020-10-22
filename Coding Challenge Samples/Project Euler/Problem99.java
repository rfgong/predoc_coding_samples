/**
Comparing two numbers written in index form like 2^11 and 3^7 is not difficult, as any calculator would confirm that 2^11 = 2048 < 3^7 = 2187.

However, confirming that 632382^518061 > 519432^525806 would be much more difficult, as both numbers contain over three million digits.

Using base_exp.txt (right click and 'Save Link/Target As...'), a 22K text file containing one thousand lines with a base/exponent pair on each line, determine which line number has the greatest numerical value.

NOTE: The first two lines in the file represent the numbers in the example given above.
*/
import java.io.File;
import java.math.BigInteger;
import java.util.Scanner;

public class Problem99 {
    public static void readIn(){
        try {
            File file = new File("src/p099_base_exp.txt");
            Scanner input = new Scanner(file);

            int line = -1;
            BigInteger largest = new BigInteger("0");

            for (int i = 0; i < 1000; i++) {
                System.out.println(i);
                String s = input.nextLine();
                BigInteger base = new BigInteger(s.substring(0, s.indexOf(',')));
                int exp = Integer.parseInt(s.substring(s.indexOf(',') + 1));
                BigInteger powed = base.pow(exp);
                if (powed.compareTo(largest) > 0) {
                    line = i + 1;
                    largest = powed;
                }
            }
            System.out.println(line);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        readIn();
    }
}
