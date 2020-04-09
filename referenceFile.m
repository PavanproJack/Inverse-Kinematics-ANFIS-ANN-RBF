l1 = 10; % length of first arm
l2 = 7; % length of second arm
l3 = 6;
%%traning data
theta1 = rand(1,12)*90; % all possible theta1 values
theta2 = rand(1,12)*90; % all possible theta2 values
theta3 = rand(1,12)*90;

% generate a grid of theta1 and theta2 and theta3 values
[THETA1, THETA2,THETA3] = ndgrid(theta1, theta2, theta3); 
% compute x coordinates

X = l1 * cos(THETA1*pi/180) + l2 * cos(THETA1*pi/180 + THETA2*pi/180)
 + l3*cos(THETA1*pi/180+THETA2*pi/180+THETA3*pi/180); 
  % compute y coordinates
Y = l1 * sin(THETA1*pi/180) + l2 * sin(THETA1*pi/180 + THETA2*pi/180)
 + l3*sin(THETA1*pi/180+THETA2*pi/180+THETA3*pi/180);
phi = THETA1 + THETA2 + THETA3;

% create training dataset
data = [X(:) Y(:) phi(:) THETA1(:) THETA2(:) THETA3(:)]; 





 % disorder the order
data_ = data(randperm(size(data,1)),:); %64000*6   //shuffle the data

%training data and validation(checking) data and testing data

trndata1=data_(1:round( size(data_,1)*5/7),1:4); %21600*4
trndata2=data_(1:round(size(data_,1)*5/7),[1,2,3,5]);
trndata3=data_(1:round(size(data_,1)*5/7),[1,2,3,6]); %5400*4

chkdata1=data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),1:4);
chkdata2= ...
    data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),[1,2,3,5]);
chkdata3= ...
    data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),[1,2,3,6]);

tesdata1=data_(round(size(data_,1)*6/7)+1:size(data_,1),1:4);
tesdata2=data_(round(size(data_,1)*6/7)+1:size(data_,1),[1,2,3,5]);
tesdata3=data_(round(size(data_,1)*6/7)+1:size(data_,1),[1,2,3,6]);

%%
%theta1 predicted by anfis,traning output
fismat1=genfis2(trndata1(:,1:3),trndata1(:,4),0.25);
fprintf('-->%s\n','Start training first ANFIS network.')
[anfis1,trnErr1,ss,anfis1_,chkErr1] = ...
anfis(trndata1(:,1:4), fismat1, [250,0,.005,.9,1.1], [0,0,0,0], chkdata1(:,1:4)); 
trnOut1 = evalfis(trndata1(:,1:3), anfis1); % theta1 predicted by anfis1
%trnRMSE1R=norm(trnOut1-trndata1(:,4))/sqrt(length(trnOut1));
chkOut1 = evalfis(tesdata1(:,1:3),anfis1_);
%chkRMSE1R=norm(chkOut1-tesdata1(:,4))/sqrt(length(chkOut1));
figure(1)
plot(trnErr1,'r')
hold on;
plot(chkErr1,'b')
title('Checking Error and Training Error of theta1')
xlabel('Number of Epochs')
ylabel('Angle Error(degree)')
legend('trnErrl','chkErr1')

figure(2)
plot(ss,'g')

%%

