# 3R Robot Inverse Kinematics Modelling with ANFIS ANN & RBF
Inverse kinematics is an under-constrained and ill-conditioned problem in Robotics that requires
the determination of the joint angles for a desired position of the end-effector. This repository addresses this problem by learning-inverse-kinematics with Adaptive Neuro Fuzzy Inference
System (ANFIS), Radial Basis Function (RBF), and Artificial Neural Network (ANN). 
Results are simulated using MATLAB 2019a version using Fuzzy Logic and Deep Learning Toolboxes.



##  3R Manipulator Arm

Algorithm followed while developing the solution is detailed here:
```
1.  Generate data from Forward Kinematics calculations mentioned below.
2.  Split the data into Train, Validation and Test partitions.
3.  Feed the data to ANFIS, RBF and ANN achitectures and compare the results.

For a 3 DOF planar redundant manipulator, the forward kinematic equations are:

X = l1cosθ1 + l2cos(θ1 + θ2) + l3cos(θ1 + θ2) + θ3)

Y = l1sinθ1 + l2sin(θ1 + θ2) + l3sin(θ1 + θ2) + θ3)

φ = θ1 + θ2 + θ3

```

Where X, Y, φ is the end-effector configuration, θ1, θ2, θ3 is the joint configuration angles. In
the context of this coursework, the length for three links are supposed to be l1 = 10, l2 = 7 and
l3 = 5 with joint angle constraints: 0 < θ1 < pi/2, 0 < θ2 < pi/2, 0 < θ3 < pi/2

Coordinates of the arm are calculated for three joints using forward kinematics

### ANFIS Modelling - Sugeno type
ANFIS architecture is tested for Performance and Mean Square Error using 3 clustering types: GridPartition, FCM Clustering and Subtractive Clustering. Install the Matlab Fuzzy Logic Toolbox, Run the script MainFile.m and selct the clustering type. Hack into the script to change the number and type of membership functions. Create the genfis object with options and pass this object to anfis and finally evaluate the model using evalfis function. Outfis is the trained model with training data. Evalfis function predicts the output with testdata against the Outfis trained model.

Finally test the accuaracy with theta_difference variables.


### RBF Modelling 
Radial basis function performs a non-linear transformation over the input vectors before input
vectors are fed for classification. By using such non-linear transformations, we can convert a linearly non-separable problems like inverse kinematics to a linearly separable problem. 

RBF increases the dimensionality of the feature vectors. Increasing the dimension, increases
the chance of linear separability.

Function fitting is the process of training a neural network on a set of inputs in order to
produce an associated set of target outputs. Here ’fitnet(hiddenSizes, trainingFunction);’ returns
a function fitting neural network with one hidden layer of size of 50 neurons trained using ’Bayesian
Regularisation’ training algorithm.

```
%% Here ’fitnet (50 , ’trainbr ’) ’ returns a function fitting neural network with
one hidden layer of size of 50 neurons trained using ’Bayesian
Regularisation’ .

% Train the network using a set of training data .
net1 = train ( net1 , train_partition_1 (: ,1:3) ’, train_partition_1 (: ,4) ’) ;

%% Once the neural network has fit the data , it forms a generalization of the
input - output relationship and now use this trained network to generate outputs for inputs it was not trained
on.

thetar1 = sim ( net1 , test_partition_1 (: ,1:3) ’) ;

Finally % Calculate the deviation from the actual value and plot the difference for the
3 joint angles .
```

### ANN Modelling 
ANNs can be applied to the problems with no algorithmic solutions or with too complex algorithmic
solutions to be found. Their ability of learning by examples makes the ANNs more flexible and
powerful than the parametric approaches.

```

```



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
