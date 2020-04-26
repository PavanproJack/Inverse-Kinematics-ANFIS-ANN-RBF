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
ANFIS architecture is tested for Performance and Mean Square Error using 3 clustering types: GridPartition, FCM Clustering and Subtractive Clustering. Install the Matlab Fuzzy Logic Toolbox, Run the script MainFile.m and selct the clustering type. 
Hack into the script to change the number and type of membership functions.

```
%% Create the genfis object with options and pass this object to anfis and finally evaluate the model using evalfis function. 

genfisOpt_1 = genfisOptions (’ GridPartition ’) ;
genfisOpt_1 . NumMembershipFunctions = [3 3 3];
genfisOpt_1 . InputMembershipFunctionType = [" gaussmf " " gaussmf " , "gaussmf "];
genfisObject_1 = genfis ( train_partition_1 (: , 1:3) , train_partition_1(: , 4) , genfisOpt_1 ) ;

%% Replicte the same for train_partition_2 and train_partition_3
%% anfisEval is a user - defined method for training ANFIS network .

anfisEval ( train_partition_1 , check_partition_1 , test_partition_1 ,genfisObject_1 , 1) ;  %% Function at anfisEval.m

```
Test the accuaracy with theta_difference variables.


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
trainingFunction = ’trainbr ’; %% Bayesian Regualrization
hiddenLayers = [10 , 10]; % 2 hidden layers with 10 neurons in each

network_1 = feedforwardnet ( hiddenLayers , trainingFunction ) ;

%%Now Train this shallow neural network with ’train ’ function to generate a trained model .

networkModel_1 = train ( network_1 , train_partition_1 (: ,1:3) ’, train_partition_1(: ,4) ’) ;

view ( networkModel_1 );
save networkModel_1 ;

load networkModel_1 ;

Q_1 = networkModel_1 ( test_partition_1 (: ,1:3) ’) ;
% Test the performance
perf_1 = perform ( networkModel_1 , Q_1 , test_partition_1 (: ,4) ’) ;
disp ( perf_1 ) ;
Replicate the same to create network models 2 and 3.
```

### Comparision and Analysis

Results of the simulation can be found in the folders: ANN Plots, RBF Plots and ANFIS Plots.

The following conclusions have been drawn by observing the results of simulation
1.  Performance of ANFIS network is significantly improved with the increase in the number
of membership functions from 3 to 5, be it a Gaussian or Bell-Shaped membership function. Subtractive and FCM Clusterings didn’t show any significant improvement in the error
for any multiple Cluster Influence Range. This implies that ANFIS converges to a better
approximation with clustering type GridPartition and 5 Gaussian/Bell-Shaped membership
functions for each input.

2.  Radial Basis Function network, deviation(in joint angles) plots are evaluated for 50 and 100
one hidden layer. Bayesian Regularization algorithm showed the better results compared to
Levenberg-Marquardt. Hidden size of 50 has converged to an acceptable error range.

3.  In Artificial Neural Network, deviation(in joint angles) plots are evaluated with two and
one hidden layers. Also here, Bayesian Regularization algorithm showed the better results
compared to Levenberg-Marquardt. Two hidden layers with 10 neurons in each has better
time complexity and accuracy compared to the network with 50 neurons in one hidden layer.
And finally, prediction performance, from the approximation accuracy and time complexity
point of view is satisfactory with the Artificial Neural Network with two hidden layers and 10
Neurons in each layer. 


## ANFIS Plot:

<img src = "/ANFIS Plots/Gauss 5MF Theta difference.png" width = "300"> 

## ANN Plot:

<img src = "/ANN Plots/ANN with 2 hidden layers Theta difference.png" width = "300"> 

## RBF Plot:

<img src = "RBF plots/RBF_50 neurons_Theta difference.png" width = "300"> 



### References


https://github.com/lq147258369/ANFIS

https://github.com/Samuel-Ayankoso/2R-Robot-Inverse-Kinematic-Using-Nonlinear-ANN

### Support or Contact
Happy to support through mail: kavvuripavankumar@gmail.com   .............
