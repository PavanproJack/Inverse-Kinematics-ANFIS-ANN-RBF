clc;
clear;
close all;


l1 = 10; % length of first arm
l2 = 7; % length of second arm
l3 = 5; % length of third arm

%%traning data
%theta1 = rand(1,12)*90; % all possible theta1 values
%theta2 = rand(1,12)*90; % all possible theta2 values
%theta3 = rand(1,12)*90; % all possible theta3 values
% generate a grid of theta1 and theta2 and theta3 values

theta1= 0 : 3.5 : 90;
theta2= 0 : 3.5 : 90;
theta3= 0 : 3.5 : 90;


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

trainingFunction = 'trainbr';
hiddenLayers = [30 30];

network_1=feedforwardnet(hiddenLayers , trainingFunction);
networkModel_1=train(network_1, train_partition_1(:,1:3)',train_partition_1(:,4)');
view(networkModel_1)
save networkModel_1;
                                                                            %y = networkModel_1(train_partition_1(:,1:3)');
                                                                            %perf = perform(networkModel_1, y , train_partition_1(:,4)');
load networkModel_1;

Q_1 = networkModel_1(test_partition_1(:,1:3)');
perf_1 = perform(networkModel_1, Q_1 ,test_partition_1(:,4)');
disp(perf_1);



network_2=feedforwardnet(hiddenLayers, trainingFunction);
networkModel_2=train(network_2, train_partition_2(:,1:3)',train_partition_2(:,4)');
view(networkModel_2)
save networkModel_2;

load networkModel_2;

Q_2 = networkModel_2(test_partition_2(:,1:3)');
perf_2 = perform(networkModel_2, Q_2 ,test_partition_2(:,4)');
disp(perf_2);


network_3=feedforwardnet(hiddenLayers, trainingFunction);
networkModel_3=train(network_3, train_partition_3(:,1:3)',train_partition_3(:,4)');
view(networkModel_3)
save networkModel_3;

load networkModel_3;

Q_3 = networkModel_3(test_partition_3(:,1:3)');
perf_3 = perform(networkModel_3, Q_3 ,test_partition_3(:,4)');
disp(perf_3);


thetaDifference_1 = test_partition_1(:,4)' - Q_1;
thetaDifference_2 = test_partition_2(:,4)' - Q_2;
thetaDifference_3 = test_partition_3(:,4)' - Q_3;



figure(1)
subplot(3,1, 1);
plot(thetaDifference_1);

figure(1)
subplot(3,1, 2);
plot(thetaDifference_2);

figure(1)
subplot(3,1, 3);
plot(thetaDifference_3);
              






%{

qt1= 0:0.5*pi/180:90*pi/180;
qt2 = 0:0.5*pi/180:90*pi/180;
qt3 = 0:0.5*pi/180:90*pi/180;

[Qt1, Qt2, Qt3]=meshgrid (qt1,qt2, qt3);
Qtr1=[reshape(Qt1,1,[])]';
Qtr2=[reshape(Qt2,1,[])]';
Qtr3=[reshape(Qt3,1,[])]';

% The training end-effector positions at varying revolute angles 
xt= l1 *cos(Qtr1)+ l2* cos(Qtr1+Qtr2) +  l3* cos(Qtr1+Qtr2+Qtr3);
yt= l1 *sin(Qtr1)+ l2* sin(Qtr1+Qtr2) +  l3* sin(Qtr1+Qtr2+Qtr3);


axis(gca,'equal') % Aspect ratio
axis([-15 15 -4 16]) % limits of the x and y axes
% define the robot workspace
plot (xt, yt ,'o');
% Read values of x and y from matlab GUI
n = 10;
coordinates = zeros(n,2);
hold on
for i=1:n
[xin, yin] = ginput(1);
coordinates(i,:) = [xin, yin];

h2=viscircles([coordinates(i,1) coordinates(i,2)], 0.2,'Color','g');
E_theta1= networkModel_1([coordinates(i,1); coordinates(i,2); 180]);
E_theta2= networkModel_2 ([coordinates(i,1); coordinates(i,2); 180]);
E_theta3= networkModel_3 ([coordinates(i,1); coordinates(i,2); 180]);

disp(E_theta1); 
disp(E_theta2);
disp(E_theta3);
f = 180 - (E_theta1 + E_theta2 + E_theta3);
disp("Error is ::: ");
disp(f);

link1x = l1*cos(E_theta1);
link1y = l1*sin(E_theta1);
link2x = l2*cos(E_theta1+E_theta2)+l1*cos(E_theta1);
link2y = l2*sin(E_theta1+E_theta2)+l1*sin(E_theta1);
link3x = l3*cos(E_theta1+E_theta2+ E_theta3)+l2*cos(E_theta1+E_theta2)+l1*cos(E_theta1);
link3y = l3*sin(E_theta1+E_theta2+ E_theta3)+l2*sin(E_theta1+E_theta2)+l1*sin(E_theta1);
Error_x=abs(coordinates(i,1)-link3x);
Error_y=abs(coordinates(i,2)-link3y);

h3= viscircles([0 0], 0.1);
% Texts to be displayed
h4=text(-12, 15, ['x input:', num2str(coordinates(i,1))]);
h5=text(-12, 14, ['y input:', num2str(coordinates(i,2))]);
h6=text(-4, 15, ['Error x:', num2str(Error_x)]);
h7=text(-4,14, ['Error y:', num2str(Error_y)]);
h8=plot([0,link1x],[0,link1y],'b','linewidth',2);
h9= viscircles([link1x,link1y], 0.1);
h10=plot([link1x,link2x],[link1y,link2y],'r','linewidth',2);
h11= viscircles([link2x,link2y], 0.1);
h12=plot([link2x,link3x],[link2y,link3y],'r','linewidth',2);
end

%}

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





