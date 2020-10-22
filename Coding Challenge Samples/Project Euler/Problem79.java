/**
 A common security method used for online banking is to ask the user for three random characters from a passcode.
 For example, if the passcode was 531278, they may ask for the 2nd, 3rd, and 5th characters; the expected reply would be: 317.

 The text file, keylog.txt, contains fifty successful login attempts.

 Given that the three characters are always asked for in order, analyse the file so as to determine the shortest possible secret passcode of unknown length.
 */

import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Scanner;
import java.util.TreeSet;

public class Problem79 {
    public static HashSet<String> readIn(){
        try {
            File file = new File("src/p079_keylog.txt");
            Scanner scan = new Scanner(file);
            HashSet<String> input = new HashSet<>();
            while (scan.hasNext()) {
                input.add(scan.nextLine());
            }
            return input;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static ArrayList<TreeSet<Integer>> partition(HashSet<String> nums, int n) {
        TreeSet<Integer> left = new TreeSet<>();
        TreeSet<Integer> right = new TreeSet<>();
        for (String s : nums) {
            int ind = s.indexOf(Integer.toString(n));
            if (ind >= 0) {
                String front = s.substring(0, ind);
                String back = s.substring(ind + 1);
                /*System.out.println(s);
                System.out.println(front);
                System.out.println(back);*/
                for (char c: front.toCharArray()) {
                    left.add(Integer.parseInt(Character.toString(c)));
                }
                for (char c: back.toCharArray()) {
                    right.add(Integer.parseInt(Character.toString(c)));
                }
            }
        }
        ArrayList<TreeSet<Integer>> parts = new ArrayList<>();
        parts.add(left);
        parts.add(right);
        return parts;
    }

    public static void main(String[] args) {
        HashSet<String> nums = readIn();
        for (int i = 0; i < 10; i++) {
            ArrayList<TreeSet<Integer>> res = partition(nums, i);
            TreeSet<Integer> left = res.get(0);
            TreeSet<Integer> right = res.get(1);
            if (left.size() == 0 && right.size() == 0) continue;
            System.out.println("NUM: " + i);
            System.out.println("LEFT: ");
            for (int a : left) {
                System.out.print(a);
            }
            System.out.println();
            System.out.println("RIGHT: ");
            for (int b : right) {
                System.out.print(b);
            }
            System.out.println();
        }

    }
}
