
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

%Plot the Workspace
%{
plot (double(X(:)), double(Y(:)) ,'.' , 'Color', [255, 153, 51] / 255)
ylabel('Y');
xlabel('X');
title('X  Y Coordinates generated for all joint angle combinations using Forward Kinematics');
%}

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

%%

%surf (double(train_partition_1(:, 1)), double(train_partition_1(:, 2)), double(train_partition_1(:, 4)) )
%colorbar

clusteringType = input('Input the type of clustering :   ');
%clusteringType = 1;
%syms clusteringType 
mF = ["gaussmf"  "gaussmf" "gaussmf"];

%mf  = input('Input the type of MF :   ');

switch clusteringType
    
    case 1   %% GridPartition
          
          disp("Selected Clustering type : Grid Partition");
          
            genfisOpt_1 = genfisOptions('GridPartition');
            genfisOpt_1.NumMembershipFunctions = [4 4 4];
            genfisOpt_1.InputMembershipFunctionType = mF;
            genfisObject_1=genfis(train_partition_1(:, 1:3), train_partition_1(:, 4), genfisOpt_1);
            
                genfisOpt_2 = genfisOptions('GridPartition');
                genfisOpt_2.NumMembershipFunctions = [4 4 4];
                genfisOpt_2.InputMembershipFunctionType = mF;
                genfisObject_2=genfis(train_partition_2(:, 1:3),train_partition_2(:, 4), genfisOpt_2);

                genfisOpt_3 = genfisOptions('GridPartition');
                genfisOpt_3.NumMembershipFunctions = [4 4 4];
                genfisOpt_3.InputMembershipFunctionType = mF;
                genfisObject_3=genfis(train_partition_3(:, 1:3),train_partition_3(:, 4), genfisOpt_3);
             
               
           
      case 2  %% FCM Clustering 
          
            genfisOpt_1 = genfisOptions('FCMClustering' );
            genfisObject_1=genfis(train_partition_1(:, 1:3),train_partition_1(:, 4), genfisOpt_1);
            
            genfisOpt_2 = genfisOptions('FCMClustering' );
            genfisObject_2=genfis(train_partition_2(:, 1:3),train_partition_2(:, 4), genfisOpt_2);
            
            genfisOpt_3 = genfisOptions('FCMClustering' );
            genfisObject_3=genfis(train_partition_3(:, 1:3),train_partition_3(:, 4), genfisOpt_3);
            
           
      case 3 %%  % Subtractive Clustering
          
            genfisOpt_1 = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange',[0.5 0.25 0.3 0.4]); 
            genfisObject_1=genfis(train_partition_1(:, 1:3),train_partition_1(:, 4), genfisOpt_1);
            
            genfisOpt_2 = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange',[0.5 0.25 0.3 0.4]); 
            genfisObject_2=genfis(train_partition_2(:, 1:3),train_partition_2(:, 4), genfisOpt_2);
            
            genfisOpt_3 = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange',[0.5 0.25 0.3 0.4]); 
            genfisObject_3 = genfis(train_partition_3(:, 1:3),train_partition_3(:, 4), genfisOpt_3);
            
    otherwise 
            disp('Something went wrong')
end



           anfisEval(train_partition_1, check_partition_1, test_partition_1, genfisObject_1, 1);
            
           anfisEval(train_partition_2, check_partition_2, test_partition_2, genfisObject_2, 2);
            
           anfisEval(train_partition_3, check_partition_3, test_partition_3, genfisObject_3, 3);














