
* move box_size back into Flock constructor and into main/FlockSystem
* change hardcoding of initial position of particles
## Plan
### One Title

* Deal with the max time_diffs and supply/get inital current supply for each title
* How to deal with the fact that particle needs the flowfield to update?
* Figure purpose of inital configuration-> later because I don't have modes yet
* use `radial_strength` and `circulation_strength` in Flock class

* map max_supply and time_diffs to the field strengths
* make system restart after iterator dies out

* display supply percentage
* change velocity flow field to acceleration flow field, so particles can gain momentum
    * **THINK about how max speed will change my visualization**

* calculate time diff regular mean too
* counter to decide how often to change the flowfield

* Make initial points to random points on a sphere?? 

### Multiple Titles
* define parameters that will allow you to hide the others and change camera view

* add option to hide inner lines and just leave outside box?

