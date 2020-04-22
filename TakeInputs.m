

clc, clear 

l1 = 10; 
l2 = 7;
l3 = 5; 

%{
theta1 = rand(1,12)*90;
theta2 = rand(1,12)*90; 
theta3 = rand(1,12)*90; 
%}

theta1= 0 : 3.5 : 90;
theta2= 0 : 3.5 : 90;
theta3= 0 : 3.5 : 90;


[THETA1, THETA2,THETA3] = ndgrid(theta1, theta2, theta3); 

X = l1 * cos(THETA1*pi/180) + l2 * cos(THETA1*pi/180 + THETA2*pi/180) + l3*cos(THETA1*pi/180+THETA2*pi/180+THETA3*pi/180); 
 
Y = l1 * sin(THETA1*pi/180) + l2 * sin(THETA1*pi/180 + THETA2*pi/180) + l3*sin(THETA1*pi/180+THETA2*pi/180+THETA3*pi/180);
phi = THETA1 + THETA2 + THETA3;

data = [X(:) Y(:) phi(:) THETA1(:) THETA2(:) THETA3(:)]; 

data_ = data(  randperm( size(data, 1) ),   :  );

%plot (double(X(:)), double(Y(:)) ,'.' , 'Color', [255, 153, 51] / 255)

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

%surf (double(train_partition_1(:, 1)), double(train_partition_1(:, 2)), double(train_partition_1(:, 4)) )
%colorbar

%clusteringType = input('Input the type of clustering :   ');
clusteringType = 1;
%syms clusteringType 
mF = ["gaussmf"  "gaussmf" "gaussmf"];
%mf  = input('Input the type of MF :   ');

switch clusteringType
      case 1  % GridPartition
          
          disp("Selected Clustering type : Grid Partition");
          
            genfisOpt_1 = genfisOptions('GridPartition');
            genfisOpt_1.NumMembershipFunctions = [3 3 3];
            genfisOpt_1.InputMembershipFunctionType = mF;
            genfisObject_1=genfis(train_partition_1(:, 1:3), train_partition_1(:, 4), genfisOpt_1);
            
                genfisOpt_2 = genfisOptions('GridPartition');
                genfisOpt_2.NumMembershipFunctions = [3 3 3 ];
                genfisOpt_2.InputMembershipFunctionType = mF;
                genfisObject_2=genfis(train_partition_2(:, 1:3),train_partition_2(:, 4), genfisOpt_2);

                genfisOpt_3 = genfisOptions('GridPartition');
                genfisOpt_3.NumMembershipFunctions = [3 3 3];
                genfisOpt_3.InputMembershipFunctionType = mF;
                genfisObject_3=genfis(train_partition_3(:, 1:3),train_partition_3(:, 4), genfisOpt_3);
             
                
            [a1, b1, c1, d1] = anfisEval(train_partition_1, check_partition_1, test_partition_1, genfisObject_1, 1);
            
            [a2, b2, c2, d2] = anfisEval(train_partition_2, check_partition_2, test_partition_2, genfisObject_2, 2);
            
            [a3, b3, c3, d3] = anfisEval(train_partition_3, check_partition_3, test_partition_3, genfisObject_3, 3);
            
            
            
      case 2  % FCM Clustering
          
            genfisOpt_1 = genfisOptions('FCMClustering' );
            genfisObject_1=genfis(trndata1(:, 1:3),trndata1(:, 4), genfisOpt);
            
            genfisOpt_2 = genfisOptions('FCMClustering' );
            genfisObject_2=genfis(trndata1(:, 1:3),trndata1(:, 4), genfisOpt);
            
            genfisOpt_3 = genfisOptions('FCMClustering' );
            genfisObject_3=genfis(trndata1(:, 1:3),trndata1(:, 4), genfisOpt);
            
            anfisOpt_1 = anfisOptions('InitialFIS',genfisObject_1);
             outFis = anfis(trainData(:,1:4), anfisOpt_1);
            
            
            
      case 3  % Subtractive Clustering
          
            genfisOpt_1 = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange',[0.5 0.25 0.3 0.4]); 
            genfisObject_1=genfis(trndata1(:, 1:3),trndata1(:, 4), genfisOpt);
            
            genfisOpt_2 = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange',[0.5 0.25 0.3 0.4]); 
            genfisObject_2=genfis(trndata1(:, 1:3),trndata1(:, 4), genfisOpt);
            
            genfisOpt_3 = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange',[0.5 0.25 0.3 0.4]); 
            genfisObject_3 = genfis(trndata1(:, 1:3),trndata1(:, 4), genfisOpt);
            
    otherwise 
            disp('Something went wrong')
end











