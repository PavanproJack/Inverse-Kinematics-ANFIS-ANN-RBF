# 3R Robot Inverse Kinematics Modelling with ANFIS ANN & RBF
Inverse kinematics is an under-constrained and ill-conditioned problem in Robotics that requires
the determination of the joint angles for a desired position of the end-effector. This repository addresses this problem by learning-inverse-kinematics with Adaptive Neuro Fuzzy Inference
System (ANFIS), Radial Basis Function (RBF), and Artificial Neural Network (ANN). 
Results are simulated using MATLAB 2019a version using Fuzzy Logic and Deep Learning Toolboxes.



## Forward Kinematics

Forward kinematics deals with computing the end-effector position with the provided joint angles. This problem can be solved in two ways
1)	Homogeneous transformations between successive frames.
2)	DH Notation approach.

DH notation is the fastest way of computing the end-effector position.

### DH Notation

This approach attaches a coordinate frame at each joint and specifies four parameters known as DH parameters for each link. Using DH parameters, DH table is created to obtain the transformation matrix between coordinate frames.

#### Preliminary Rules: 
1.	You must have at least one more frame than there are joints - one frame must be on the end effector
2.	All axes must be drawn either up, down, right, left or in the first or third quadrant.
3.	The Z-axis must be the axis of revolution or the direction of motion
4.	The X-axis must be perpendicular to the Z-axis of the frame before it.
5.	The Y-axis must be drawn so the whole frame follows the right-hand rule.


| Frame(i) | θ | 𝜶 | r | d |
|-------|--------|---------|--------|---------|
| 1 | θ1 | 90 | 0 | L1 |
| 2 | θ2 | 0 | L2 | 0 |
| 3 | θ3 | 0 | L3 | 0 |
| 4 | θ4 + 90 | -90 | L4 | 0 |
| 5 | θ5 | 0 | 0 | L5 |


#### Workspace Plotting:
A really important consideration with any robot is the set of all possible points that it can reach and we refer to this volume as workspace of the robot. It also shows the volume around the body where it cannot reach either. And this is due to mechanical limits on the range of motion of particular joints.Here we plot the workspace of the Lynx motion robot with all possible joint angles within their corresponding joint limits. Script for plotting workspace can be found in WorkSpace.m file.


<img src = "WorkspaceXY.png" width = "300">  <img src = "Workspace XZ axes.png" width = "300"> 

<img src = "Workspace YZ axes.png" width = "300"> <img src = "WorkspaceXYZ axes.png" width = "300">

## Inverse Kinematics

Inverse Kinematics (IK) is defined as the problem of determining a set of appropriate joint configurations for which the end effector move to desired positions as smoothly, rapidly, and as accurately as possible.

In comparison to forward kinematics, computing inverse kinematics is computationally intensive.
There exist many methods for solving this problem.
  a)	Jacobian Inverse Methods 
  b)	Algebraic approach
  c)	Geometrical approach
  d)	Decoupling technique
  e)	Inverse transformation technique
  
We use RObotics Toolbox to solve the inverse kinematics problem.

# Motion Planning

Motion planning includes four steps.
1. Task planning (for eg. movement from positions A to B)
2. Path Planning (generating a set of points that will take me close to B from A)
3. Trajectory planning (build a trajectory with the set of points while avoiding collisions)
4. Controller actuation to complete the action 

For example, a welding robot that welds the joints. Here, besides the initial and final positions, the path of the end effector has the significance to make the correct welding.

### Draw the character ‘ W ’
This task is achieved using the Robotics ToolBox developed by Petercorke. 

Algorithm for planning the trajectory:
1.	Identify spatial coordinates of the shape/trajectory. Here it is ‘W’.
2.	Calculate the transformation matrices of all the points with respect to base frame.
3.	Now compute the inverse kinematics and find out the joint angles.
4.	Use ‘mstraj’ or ‘jtraj’ get the way points and plot them together to form the trajectory.

Script executing this algorithm can be found under PathPlanning.m file in this repository.

<img src = "Straight Line Trajectory.png" width = "300">  <img src = "Free motion Trajectory.png" width = "300"> 

<img src = "Obstacle Avoidance Trajectory.png" width = "300"> 



### References


https://github.com/lq147258369/ANFIS

https://github.com/Samuel-Ayankoso/2R-Robot-Inverse-Kinematic-Using-Nonlinear-ANN

### Support or Contact
Happy to support through mail: kavvuripavankumar@gmail.com   .............
