# Processing Particle Visualization
---
## Concept
This project was completed for the 3D data visualization project that was required for my MAT 259 class. For this project, I would like to map statistics from my dataset to the parameters of a physical system. The specific statistics are:
1. the current supply in the library of each "title" that I am considering
2. the time difference between when a specific book is checked into the library and when it is checked out again.

These values will be mapped respectively to:
1. The strength of a 1/r radial field.
2. the strength of a 1/r circulation field. also the color of the particles.
This field is what will dictate the motion of many particles, which will exist inside a box. Because the values of the current supply and time difference will change over time, the particles' motions will thus be governed by a time varying acceleration field.

To summarize, the behavior of the particles in relation to the supply and demand is roughly:
1. as supply goes up, the strength of the radial field increases and pulls the particles into the center, making the system more ordered.
2. as supply goes down, the radial strength decreases , so particles are able to explore a greater region of the cube. To emphasis this, I have added a springlike noise field.
3. as demand goes up, circulation goes up, and the system will move circulate faster. Note that I will be using an exponentially smoothed time_diffs, rather than a average or instantaneous one.

## Running the Program

## Result
![first](final_one.png)
The buttons on top allow you to look the particle system that corresponds to each of the titles individually. 
![second](final_two.png)
The reset button will bring you back to looking at all 4 systems at once.

## Misc
To develop my software development abilities, I have tried to:
    * keep global variables to a minimal, and prepend the global variables which were acessed outside of the `Mat259_3D.pde` file with `g_`
    * explicitly specifying objects as arguments to functions that modify them
    * drew out "communications" between objects in terms of blobs and arrows before coding, so as to purpose of each class/object as tidy as possible.
