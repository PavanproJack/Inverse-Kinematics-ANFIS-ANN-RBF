clc, clear 

%% Data Generation
% Defining Link Lengths here..
linkLength_1 = 10;                         % length of first arm
linkLength_2 = 7;                           % length of second arm
linkLength_3 = 5;                           % length of third arm 

%%traning data
%theta1 = rand(1,12)*90; % all possible theta1 values
%theta2 = rand(1,12)*90; % all possible theta2 values
%theta3 = rand(1,12)*90; % all possible theta3 values
% generate a grid of theta1 and theta2 and theta3 values

theta_1= 0 : 3.5 : 90;
theta_2= 0 : 3.5 : 90;
theta_3= 0 : 3.5 : 90;

% Replicating the grid vectors theta_1, theta_2, theta_3 to produce an n-dimensional full grid
[THETA1, THETA2,THETA3] = ndgrid(theta_1, theta_2, theta_3); 

%%Forward Kinematics... Let 'X', 'Y', and 'phi' be the end effector configuration. Geometrically, they are caluculated as ...

X = linkLength_1 * cos(THETA1*pi/180) + ...
    linkLength_2 * cos(THETA1*pi/180 + THETA2*pi/180) + ...
    linkLength_3*cos(THETA1*pi/180+THETA2*pi/180+THETA3*pi/180); 
 
Y = linkLength_1 * sin(THETA1*pi/180) + ...
    linkLength_2 * sin(THETA1*pi/180 + THETA2*pi/180) + ...
    linkLength_3*sin(THETA1*pi/180+THETA2*pi/180+THETA3*pi/180);

phi = THETA1 + THETA2 + THETA3;

data = [X(:) Y(:) phi(:) THETA1(:) THETA2(:) THETA3(:)]; 

% Randomly shuffle the data
data_ = data(  randperm( size(data, 1) ),   :  );

%% Data Partitioning into Train, Test and Validation sets. 

train_partition_1 = data_(1:round( size(data_,1)*5/7),1:4);  
train_partition_2 = data_(1:round(size(data_,1)*5/7),[1,2,3,5]);
train_partition_3 = data_(1:round(size(data_,1)*5/7),[1,2,3,6]);  

check_partition_1 = data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),1:4);
check_partition_2 = data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),[1,2,3,5]);
check_partition_3 = data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),[1,2,3,6]);

test_partition_1 = data_(round(size(data_,1)*6/7)+1:size(data_,1),1:4);
test_partition_2 = data_(round(size(data_,1)*6/7)+1:size(data_,1),[1,2,3,5]);
test_partition_3 = data_(round(size(data_,1)*6/7)+1:size(data_,1),[1,2,3,6]);


%% Now train the model

% Feedforward neural network with two hidden layers of 10 neurons in each.
% Training function used is Bayesian Regularisation.

trainingFunction = 'trainbr';
hiddenLayers = [10, 10];
%hiddenLayers = 50;

network_1=feedforwardnet(hiddenLayers , trainingFunction);
networkModel_1=train(network_1, train_partition_1(:,1:3)',train_partition_1(:,4)');
view(networkModel_1)
save networkModel_1;
                                                                            %y = networkModel_1(train_partition_1(:,1:3)');
                                                                            %perf = perform(networkModel_1, y , train_partition_1(:,4)');
load networkModel_1;

predicted_Theta_1 = networkModel_1(test_partition_1(:,1:3)');
perf_1 = perform(networkModel_1, predicted_Theta_1 ,test_partition_1(:,4)');
disp(perf_1);



network_2=feedforwardnet(hiddenLayers, trainingFunction);
networkModel_2=train(network_2, train_partition_2(:,1:3)',train_partition_2(:,4)');
view(networkModel_2)
save networkModel_2;

load networkModel_2;

predicted_Theta_2 = networkModel_2(test_partition_2(:,1:3)');
perf_2 = perform(networkModel_2, predicted_Theta_2 ,test_partition_2(:,4)');
disp(perf_2);


network_3=feedforwardnet(hiddenLayers, trainingFunction);
networkModel_3=train(network_3, train_partition_3(:,1:3)',train_partition_3(:,4)');
view(networkModel_3)
save networkModel_3;

load networkModel_3;

predicted_Theta_3 = networkModel_3(test_partition_3(:,1:3)');
perf_3 = perform(networkModel_3, predicted_Theta_3 ,test_partition_3(:,4)');
disp(perf_3);


thetaDifference_1 = test_partition_1(:,4)' - predicted_Theta_1;
thetaDifference_2 = test_partition_2(:,4)' - predicted_Theta_2;
thetaDifference_3 = test_partition_3(:,4)' - predicted_Theta_3;

  
%% Plot the Deviation from the targets.

figure(1)
subplot(3,1, 1);
plot(thetaDifference_1);
ylabel(['Theta 1 Error']);
titles= ['Desired theta 1 - Predicted theta 1 (in degrees)'];
title(titles);

figure(1)
subplot(3,1, 2);
plot(thetaDifference_2);
ylabel(['Theta 2 Error']);
titles= ['Desired theta 2 - Predicted theta 2 (in degrees)'];
title(titles);

figure(1)
subplot(3,1, 3);
plot(thetaDifference_3);
ylabel(['Theta 3 Error']);
titles= ['Desired theta 3 - Predicted theta 3 (in degrees)'];
title(titles);
