%% Symbolic calculations for the double pendulum
clear all
syms theta1 theta2 theta1dot theta2dot theta1ddot theta2ddot real
syms tau real
%syms m1 m2 ell1 ell2 g real
m1 = 1; m2 = 1; ell1 = 1; ell2 = 1; % use numerical values for model params
syms g real

B=[1;0]; % underactuated

q=[theta1;theta2];
qdot=[theta1dot;theta2dot];
qddot=[theta1ddot;theta2ddot];


x1=ell1*[-sin(theta1);cos(theta1)];
x1dot=diff(x1,theta1)*theta1dot;
x2 = x1 + ell2*[-sin(theta2);cos(theta2)];
x2dot=diff(x2,theta1)*theta1dot + diff(x2,theta2)*theta2dot;

K = simplify(1/2*m1*(x1dot'*x1dot) + 1/2*m2*(x2dot'*x2dot));
K = simplify(K); % kinetic energy
P = m1*[0 g]*x1 + m2*[0 g]*x2; % potential energy
P = simplify(P);
L=K-P; % Lagrangian
E = K+P; % Total energy

dLdqdot=jacobian(L,qdot)';
dtdLdqdot=jacobian(dLdqdot,[q;qdot])*[qdot;qddot];
dLdq=jacobian(L,q)';
EL=simplify(dtdLdqdot-dLdq - B*tau);

%% Get coordinates representation D*qddot + C*qdot + DelP = B*tau
[D,b]=equationsToMatrix(EL,[theta1ddot;theta2ddot]);
DelP = simplify(jacobian(P, q)');
C = simplify(-b - DelP + B*tau);
C = [0 theta2dot*sin(theta1 - theta2);
 -theta1dot*sin(theta1 - theta2) 0];

%% Get a state-space model dot(x) = f(x) + g(x)u, x = (q, qdot);
f2 =  simplify(-D\(C*qdot + DelP));
g2 = simplify(D\B);
f = [qdot;f2];
g= [zeros(size(q));g2];

