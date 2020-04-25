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

trndata1=data_(1:round( size(data_,1)*5/7),1:4); %21600*4
chkdata1=data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),1:4);
tesdata1=data_(round(size(data_,1)*6/7)+1:size(data_,1),1:4);

genOpt = genfisOptions('GridPartition');
genOpt.NumMembershipFunctions = [4 4 4];
genOpt.InputMembershipFunctionType = ["trimf" "gaussmf", "gaussmf"];

genfisObject=genfis(trndata1(:, 1:3),trndata1(:, 4), genOpt);


anfisOpt = anfisOptions('InitialFIS',genfisObject);
anfisOpt.DisplayANFISInformation = 0;
anfisOpt.DisplayErrorValues = 0;
anfisOpt.DisplayStepSize = 0;
anfisOpt.DisplayFinalResults = 0;
anfisOpt.ValidationData = chkdata1;

%  [fis,trainError,stepSize,chkFIS,chkError] = anfis(trainingData,options)

fprintf('-->%s\n','Start training first ANFIS network.')
%outFIS = anfis(trndata1(:,1:4), anfisOpt);

[outFis,trainError,stepSize, chkFIS, chkError] = anfis(trndata1(:,1:4), anfisOpt);

trnOut1 = evalfis(outFis, trndata1(:,1:3) );

chkOut1 = evalfis(chkFIS, tesdata1(:,1:3) );   

theta1_diff=tesdata1(:,4)-chkOut1;





%{
figure(1)
plot(trainError,'r')
hold on;
plot(chkError,'b')
%}









