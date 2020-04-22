qdmax = [1 1 1 ];
velocity = 0.1;
acceleration = 0.8;  
K = {'r', 'LineWidth', 2};



L1 = 10;
L2 = 5;
L3 =  7;

% SL(i) = Link( [Theta      d       a       alpha] );

SL(1) = Link([0,L1,0,pi/2]);
SL(2) = Link([0,0,L2,0]);
SL(3) = Link([0,0,L3,0]);

Robot = SerialLink(SL);

point1 = [4 3 0];   %[400 -900 0]
point2 = [4 5 0];   % [300 500 0]
point3 = [-4 -5 0];   % [300 500 0]

M1 = transl(point1) * trotx(180, 'deg');
M2 = transl(point2) * trotx(180, 'deg');
M3 = transl(point3) * trotx(180, 'deg');

mask =  [1 1 1 0 0 0];

%=========================Robot Inverse Kinematics start here
q1 = Robot.ikine(M1, 'mask', mask );
q2 = Robot.ikine(M2, 'mask', mask );
q3 = Robot.ikine(M3, 'mask', mask);

P1 = q1(1, : );
P2 = q2(1, : );
P3 = q3(1, : );


Path12 = [P1; P2];
Path23 = [P2; P3];
 


finalPath = [Path12; Path23];

A = mstraj( finalPath, qdmax, [],[],velocity,acceleration); %trajectory

Robot.plot(A, 'trail', K);
 



%{
f = Robot.fkine([0, 0, 0]);

for th = 0 : 0.1 : pi/2
    Robot.plot([th, th, th]);
    pause(0.25);
end
disp(f)
%}




