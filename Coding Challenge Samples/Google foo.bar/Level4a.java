/*
Rooms are number from 0-N inclusive
Given an array of entrance rooms and an array of exit rooms,
find the peak number of "bunnies" that can step into the exit state at any given time.
To get from the entrance room, bunnies may need to traverse multiple intermediate rooms.
The size and capacity of hallways is given in path. Where path[x][y] gives the numbers of bunnies that
can fit on this path at a given time.
 */
import java.util.HashSet;
import java.util.HashMap;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Random;

public class Level4a {

    public static int solution(int[] entrances, int[] exits, int[][] path) {
        int maxFlow = 0;
        for (int i = 0; i < 100; i++) {
            int runResult = solutionH(entrances, exits, path);
            if (runResult > maxFlow) {
                maxFlow = runResult;
            }
            // System.out.println("RUN #" + i + ": " + runResult);
        }
        return maxFlow;
    }


    public static int solutionH(int[] entrances, int[] exits, int[][] path) {
        // Your code here
        HashSet<Integer> exitMembers = new HashSet<>();
        HashMap<Integer, Integer> inflow = new HashMap<>();
        ArrayDeque<Integer> fringe = new ArrayDeque<>();
        HashSet<Integer> fringeMem = new HashSet<>();
        HashSet<Integer> closed = new HashSet<>();
        for (int ex: exits) {
            exitMembers.add(ex);
        }
        for (int e: entrances) {
            fringe.addLast(e);
            fringeMem.add(e);
        }
        while (fringe.size() != 0) {
            int current = fringe.removeFirst();
            fringeMem.remove(current);
            closed.add(current);
            if (exitMembers.contains(current)) {
                continue;
            }

            int maxIn = Integer.MAX_VALUE;
            if (inflow.containsKey(current)) {
                // this is not entrance
                maxIn = inflow.get(current);
                if (maxIn == 0) {
                    continue;
                }
            }
            int[] halls = path[current];
            for (int i: randIndSeq(halls.length)) {
                if (halls[i] == 0) {
                    continue;
                }
                // naively allocate child inflows
                if (maxIn > 0) {
                    int hallSize = halls[i];
                    if (hallSize > maxIn) {
                        if (inflow.containsKey(i)) {
                            inflow.put(i, inflow.get(i) + maxIn);
                        } else {
                            inflow.put(i, maxIn);
                        }
                        maxIn = 0;
                    } else {
                        if (inflow.containsKey(i)) {
                            inflow.put(i, inflow.get(i) + hallSize);
                        } else {
                            inflow.put(i, hallSize);
                        }
                        maxIn += -1 * hallSize;
                    }
                    if (!fringeMem.contains(i) && !closed.contains(i)) {
                        fringe.addLast(i);
                        fringeMem.add(i);
                    }
                } else {
                    if (!inflow.containsKey(i)) {
                        inflow.put(i, 0);
                    }
                }
            }
        }
        int endflow = 0;

        /*
        for (int k : inflow.keySet()) {
            System.out.println("KEY: " + k + " VAL: " + inflow.get(k));
        }
        */

        for (int e : exits) {
            if (inflow.containsKey(e)) {
                endflow += inflow.get(e);
            }
        }
        return endflow;
    }

    public static ArrayList<Integer> randIndSeq(int n) {
        ArrayList<Integer> ordered = new ArrayList<>();
        ArrayList<Integer> shuffled = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            ordered.add(i);
        }
        Random rand = new Random();
        while (ordered.size() != 0) {
            int nextInd = rand.nextInt(ordered.size());
            shuffled.add(ordered.remove(nextInd));
        }
        return shuffled;
    }

    /*
    public static int numOutPaths(int[] hall) {
        int count = 0;
        for (int i: hall) {
            if (i > 0) {
                count += 1;
            }
        }
        return count;
    }
    */

    public static void main(String[] args) {
        /*
        // TEST #1 = 16
        */
        int[] entrances = {0, 1};
        int[] exits = {4, 5};
        int[][] paths = {{0, 0, 4, 6, 0, 0}, {0, 0, 5, 2, 0, 0}, {0, 0, 0, 0, 4, 4}, {0, 0, 0, 0, 6, 6}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}};
        System.out.println(solution(entrances, exits, paths));

        /*
        // TEST #2 = 6
        int[] entrances = {0};
        int[] exits = {3};
        int[][] paths = {{0, 7, 0, 0}, {0, 0, 6, 0}, {0, 0, 0, 8}, {9, 0, 0, 0}};
        System.out.println(solution(entrances, exits, paths));
        */
        /*
        // HELPER TEST
        ArrayList<Integer> res = randIndSeq(9);
        for (int i: res) {
            System.out.println(i);
        }
        */
    }

}
