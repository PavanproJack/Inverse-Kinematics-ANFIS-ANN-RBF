clc;
clear;
close all;


l1 = 10; % length of first arm
l2 = 7; % length of second arm
l3 = 5; % length of third arm
%%traning data
theta1 = rand(1,12)*90; % all possible theta1 values
theta2 = rand(1,12)*90; % all possible theta2 values
theta3 = rand(1,12)*90; % all possible theta3 values
% generate a grid of theta1 and theta2 and theta3 values
[THETA1, THETA2,THETA3] = ndgrid(theta1, theta2, theta3); 
% compute x coordinates
X = l1 * cos(THETA1*pi/180) + l2 * cos(THETA1*pi/180 + THETA2*pi/180) + l3*cos(THETA1*pi/180+THETA2*pi/180+THETA3*pi/180); 
  % compute y coordinates
Y = l1 * sin(THETA1*pi/180) + l2 * sin(THETA1*pi/180 + THETA2*pi/180) + l3*sin(THETA1*pi/180+THETA2*pi/180+THETA3*pi/180);
phi = THETA1 + THETA2 + THETA3;
% create training dataset
data = [X(:) Y(:) phi(:) THETA1(:) THETA2(:) THETA3(:)]; 

data_ = data(  randperm( size(data, 1) ),   :  );

%Data Splitting
train_partition_1 = data_(1:round( size(data_,1)*5/7),1:4);  
train_partition_2 = data_(1:round(size(data_,1)*5/7),[1,2,3,5]);
train_partition_3 = data_(1:round(size(data_,1)*5/7),[1,2,3,6]);  

check_partition_1 = data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),1:4);
check_partition_2 = data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),[1,2,3,5]);
check_partition_3 = data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),[1,2,3,6]);

test_partition_1 = data_(round(size(data_,1)*6/7)+1:size(data_,1),1:4);
test_partition_2 = data_(round(size(data_,1)*6/7)+1:size(data_,1),[1,2,3,5]);
test_partition_3 = data_(round(size(data_,1)*6/7)+1:size(data_,1),[1,2,3,6]);
%

%{
%Neural Network
% This code will solve the inverse kinematics of a 2R Planar robot
clc;
clear;
close all;
l_1= 10;
l_2= 7;
l_3 = 5;
% Training points of the revolute angle 1 and 2
qt1= 0:0.5*pi/180:90*pi/180;
qt2 = 0:0.5*pi/180:90*pi/180;
qt3 = 0:0.5*pi/180:90*pi/180;

[Qt1 Qt2]=meshgrid (qt1,qt2);
Qtr1=[reshape(Qt1,1,[])]';
Qtr2=[reshape(Qt2,1,[])]';

% The training end-effector positions at varying revolute angles 
xt= l_1 *cos(Qtr1)+ l_2* cos(Qtr1+Qtr2);
yt= l_1 *sin(Qtr1)+ l_2* sin(Qtr1+Qtr2);
%}

% % The matrix of the training data (3 by n)
%datatr1= [xt yt Qtr1];% system 1
inputs1= [train_partition_1(:,1:3)'];
target1=[train_partition_1(:,4)'];
net1=feedforwardnet(50);
net_sys1=train(net1,inputs1,target1);
save net_sys1;
load net_sys1;

%datatr2= [xt yt Qtr2];% system 2
inputs2= [train_partition_2(:,1:3)'];
target2= [train_partition_2(:,4)'];
net2=feedforwardnet(50);
net_sys2=train(net2,inputs2,target2);
save net_sys2;
load net_sys2;
hold on




