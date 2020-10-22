import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

/**
 * Elevator Maintenance
 ====================

 You've been assigned the onerous task of elevator maintenance - ugh! It wouldn't be so bad, except that all the elevator documentation has been lying in a disorganized pile at the bottom of a filing cabinet for years, and you don't even know what elevator version numbers you'll be working on.

 Elevator versions are represented by a series of numbers, divided up into major, minor and revision integers. New versions of an elevator increase the major number, e.g. 1, 2, 3, and so on. When new features are added to an elevator without being a complete new version, a second number named "minor" can be used to represent those new additions, e.g. 1.0, 1.1, 1.2, etc. Small fixes or maintenance work can be represented by a third number named "revision", e.g. 1.1.1, 1.1.2, 1.2.0, and so on. The number zero can be used as a major for pre-release versions of elevators, e.g. 0.1, 0.5, 0.9.2, etc (Commander Lambda is careful to always beta test her new technology, with her loyal henchmen as subjects!).

 Given a list of elevator versions represented as strings, write a function answer(l) that returns the same list sorted in ascending order by major, minor, and revision number so that you can identify the current elevator version. The versions in list l will always contain major numbers, but minor and revision numbers are optional. If the version contains a revision number, then it will also have a minor number.

 For example, given the list l as ["1.1.2", "1.0", "1.3.3", "1.0.12", "1.0.2"], the function answer(l) would return the list ["1.0", "1.0.2", "1.0.12", "1.1.2", "1.3.3"]. If two or more versions are equivalent but one version contains more numbers than the others, then these versions must be sorted ascending based on how many numbers they have, e.g ["1", "1.0", "1.0.0"]. The number of elements in the list l will be at least 1 and will not exceed 100.

 Languages
 =========

 To provide a Python solution, edit solution.py
 To provide a Java solution, edit solution.java

 Test cases
 ==========

 Inputs:
 (string list) l = ["1.1.2", "1.0", "1.3.3", "1.0.12", "1.0.2"]
 Output:
 (string list) ["1.0", "1.0.2", "1.0.12", "1.1.2", "1.3.3"]

 Inputs:
 (string list) l = ["1.11", "2.0.0", "1.2", "2", "0.1", "1.2.1", "1.1.1", "2.0"]
 Output:
 (string list) ["0.1", "1.1.1", "1.2", "1.2.1", "1.11", "2", "2.0", "2.0.0"]

 Use verify [file] to test your solution and see how it does. When you are finished editing your code, use submit [file] to submit your answer. If your solution passes the test cases, it will be removed from your home folder.

 */
public class Level2b {

    public static String[] answer(String[] l) {

        if (l.length <= 1) {
            return l;
        }

        ArrayList<BigInteger> mSdigits = new ArrayList<>();
        ArrayList<String> sorted = new ArrayList<>();

        // retrieve the MSD of each elevator version
        for (String elevator : l) {
            int digitEnd = elevator.indexOf(".");
            if (digitEnd == -1) {
                mSdigits.add(new BigInteger(elevator));
            } else {
                String mSdig = elevator.substring(0, digitEnd);
                mSdigits.add(new BigInteger(mSdig));
            }
        }
        // sort the MSDs
        Collections.sort(mSdigits);

        // split by MSD and sort by remaining parts
        BigInteger previous = new BigInteger("-1");
        for (BigInteger msd: mSdigits) {
            if (!msd.equals(previous)) {
                // get the remaining parts of elevators with matching msd
                // set aside and add if msd exactly equals version
                ArrayList<String> done = new ArrayList<>();
                ArrayList<String> unsorted = new ArrayList<>();
                for (String elevator : l) {
                    int digitEnd = elevator.indexOf(".");
                    if (digitEnd == -1) {
                        if (elevator.equals(msd.toString())) {
                            done.add(elevator);
                        }
                    } else {
                        String mSdig = elevator.substring(0, digitEnd);
                        if (mSdig.equals(msd.toString())) {
                            unsorted.add(elevator.substring(digitEnd + 1));
                        }
                    }
                }
                sorted.addAll(done);
                String[] rSorted = answer(unsorted.toArray(new String[unsorted.size()]));
                for (String s: rSorted) {
                    sorted.add(msd.toString() + "." + s);
                }
                previous = msd;
            }
        }

        return sorted.toArray(new String[sorted.size()]);
    }

    public static void main(String[] args) {
        String[] test = new String[]{"0.0.0", "0.0.0", "0", "0.0", "0", "0.0.0", "0.0","2.0", "2.0.0", "2.0", "2", "0.1", "1.2.1", "0.2", "2.0", "2.0", "2", "0.1", "0.2.1", "0.0.2", "0.0.2", "0.2.1", "0.0.432", "0.0.1212", "2.0.0",  "0.13121313131313.0", "0.13121313131313.0",
                "0.13121313131312.0", "0.13121313131314.0", "1291929192192919291239942934923", "321301293091290313.21930129320.210", "1291929192192919291239942934923.0", "321301293091290313.21930129320.219", "1291929192192919291239942934923.0.0", "321301293091290313.219301292132013092910391203912039921032910321903921039320.210"};
        String[] result = answer(test);
        System.out.println(Arrays.toString(result));
    }
}
