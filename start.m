

inputData = (0:0.1:10)';
outputData = sin(2*inputData)./exp(inputData/5);

%inputData = [rand(10,1) 10*rand(10,1)-5];
%outputData = sin(2* rand(10,1));
%outputData = rand(10,1);
disp(class(inputData));

disp(outputData);


genOpt = genfisOptions('GridPartition');
genOpt.NumMembershipFunctions = 5;
genOpt.InputMembershipFunctionType =  "gaussmf";

fis = genfis(inputData, outputData, genOpt);

%{
[x,mf] = plotmf(fis,'input',1);
subplot(2,1,1)
plot(x,mf)
xlabel('input 1 (gaussmf)')
[x,mf] = plotmf(fis,'input',2);
subplot(2,1,2)
plot(x,mf)
xlabel('input 2 (trimf)')

%}


opt = anfisOptions('InitialFIS', fis);
opt.DisplayANFISInformation = 0;
opt.DisplayErrorValues = 0;
opt.DisplayStepSize = 0;
opt.DisplayFinalResults = 0;


outFIS = anfis([inputData outputData],opt);


plot(inputData, outputData, inputData, evalfis(outFIS, inputData));
legend('Training Data','ANFIS Output')







