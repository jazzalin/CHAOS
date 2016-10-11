% James Azzalini - Simplifying DP motion equations for RK4

%Variables and parameters
syms ax1 ax2 ay1 ay2 g th1 th2 w1 w2 dw1 dw2 L1 L2 m1 m2

%Acceleration of members L1 and L2
ax1 = -w1^2*L1*sin(th1)+dw1*L1*cos(th1);
ay1 = w1^2*L1*cos(th1) + dw1*L1*sin(th1);
ax2 = ax1-w2^2*L2*sin(th2)+dw2*L2*cos(th2);
ay2 = ay1+w2^2*L2*cos(th2)+dw2*L2*sin(th2);

%Intermediary equations of motion
eqn1 = sin(th1)*(m1*ay1+m2*ay2+m2*g+m1*g) == -cos(th1)*(m1*ax1+m2*ax2);
eqn2 = sin(th2)*(m2*ay2+m2*g) == -cos(th2)*(m2*ax2);
sol = solve([eqn1, eqn2], [dw1, dw2]);
dw1Sol = sol.dw1
dw2Sol = sol.dw2
dw1 = simplify(dw1Sol)
dw2 = simplify(dw2Sol)

%The 2nd order DEs dw1 and dw2 are taken as 4 1st order DEs for RK4
% w1 --> theta_1-dot = angular velocity of member L1
% w2 --> theta_2-dot = angular velocity of member L2
% dw1 --> w1-dot = angular acceleration of member L1
% dw2 --> w2-dot = angular acceleration of member L2









