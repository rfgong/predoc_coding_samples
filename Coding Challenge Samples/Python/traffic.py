"""
## 2. Traffic simulator

In a simple traffic simulator, each car is in one lane and can't
change lanes. Each car moves at a constant speed forward if/until
it touches a car in front, then it adjusts to move at that cars
speed. The road is infinite and straight. Each car is a point and
doesn't have a length/width. In case two cars have the same point,
preserve the order in the input list (e.g. if both have the same
distance, the one with the higher index in the input list is ahead).

In Python the car will be a tuple, `(lane, distance, speed)`. lane
is an int in [0, number of lanes), distance is the current distance
in the lane (meters, from some starting 0 point), and speed is
meters/second.

This code generates a list of initial cars.

```
import random
def generate_random_cars(car_count,
                         lane_count,
                         min_distance=0,
                         max_distance=20,
                         min_speed=1,
                         max_speed=10):
  return [
    (
      random.randint(0, lane_count - 1),
      min_distance + (max_distance - min_distance) * random.random(),
      min_speed + (max_speed - min_speed) * random.random()
    )
    for _ in xrange(0, car_count)
    ]
```

Write a function that takes the list of initial cars and computes the
distance of each car after `elapsed_time` seconds of driving. It should
return a new list of tuples in the same order with the updates distance
values.

Some example cases are below.

```
cars = [(0, 0, 2), (0, 1, 1)]
update_distance(cars, elapsed_time=1) == [(0, 2, 2), (0, 2, 1)]
update_distance(cars, elapsed_time=2) == [(0, 3, 2), (0, 3, 1)]
update_distance(cars, elapsed_time=3) == [(0, 4, 2), (0, 4, 1)]
```

```
cars = [(0, 0, 5), (1, 0, 2)]
update_distance(cars, elapsed_time=1) == [(0, 5, 5), (1, 2, 2)]
update_distance(cars, elapsed_time=2) == [(0, 10, 5), (1, 4, 2)]
update_distance(cars, elapsed_time=3) == [(0, 15, 5), (1, 6, 2)]
```
"""
import random


def generate_random_cars(car_count,
                         lane_count,
                         min_distance=0,
                         max_distance=20,
                         min_speed=1,
                         max_speed=10):
    return [
        (
            random.randint(0, lane_count - 1),
            min_distance + (max_distance - min_distance) * random.random(),
            min_speed + (max_speed - min_speed) * random.random()
        )
        for _ in range(0, car_count)
    ]


# 2.
def run_cars(car_list, time):
    """
    Takes in a list of car tuples (lane, distance, speed) where distance and speed
    may have float values (assuming we use generate_random_cars)
    Returns a list of tuples where car distances are updated
    """
    # Dictionary mapping lane number to list of cars in it
    lanes = {}
    # List for storing car objects
    cars = []
    # create car objects and put them into lanes
    for i in range(len(car_list)):
        car_object = Car(car_list[i], i)
        cars.append(car_object)
        # put the car into appropriate lane
        if car_object.lane in lanes:
            lanes[car_object.lane].append(car_object)
        else:
            lanes[car_object.lane] = [car_object]
    # sort the lanes so that the cars with the greatest distance appear first
    # ties are broken so the car with higher index in the input list is ahead
    for lane in lanes:
        lanes.get(lane).sort(key=lambda x: (x.distance, x.index), reverse=True)
    """
    for lane in lanes:
        print("Lane " + str(lane) + ": " + str([car.toTuple() for car in lanes.get(lane)]))
    """
    # loop for time
    for _ in range(time):
        # run the cars in each lane, going from cars at greatest distance to cars with least distance
        for lane in lanes:
            cars_lane = lanes.get(lane)
            for i in range(len(cars_lane)):
                # run the car forward
                cars_lane[i].distance += cars_lane[i].speed
                # if the car is not the furthest car, check if it would run into the car in front of it
                if i and (cars_lane[i].distance > cars_lane[i - 1].distance):
                    # the car should not have passed the car in front of it
                    # a simple proof by induction shows this car will not pass any car's it shouldn't
                    cars_lane[i].distance = cars_lane[i - 1].distance
    # Return tuples in same order
    return [car.toTuple() for car in cars]


class Car:
    """
    Simple class that represents a car
    """
    def __init__(self, tuple, index):
        """
        index: the index of this car in the run_cars list
        """
        self.index = index
        self.lane = tuple[0]
        self.distance = tuple[1]
        self.speed = tuple[2]

    def toTuple(self):
        """
        Returns a tuple representing the car
        """
        return self.lane, self.distance, self.speed

