clc;
clearvars;
close all;
options = odeset('RelTol',1e-12, 'abstol', 1e-12); % will be used to set options for ODE solver
t_span = [0 20]; % amount of time we will simulate for

x0 = [0;0;0]; % Set the initial conditions


% Now simulate the system
[t, x] = ode45(@unicycle, t_span, x0, options); %% medium accuracy ODE solver, Runge-Kutta method

figure;
plot(t, x(:, 1), t, x(:, 2));
legend('$x(t)$', '$y(t)$', 'Interpreter','latex', 'FontSize', 14);
xlabel('time (s)', 'Interpreter','latex', 'FontSize', 17);
grid on;

figure;
plot(x(:, 1), x(:, 2));
xlabel('$x_1(t) = x(t)$', 'Interpreter','latex', 'FontSize', 17);
ylabel('$x_2(t) = y(t)$', 'Interpreter','latex', 'FontSize', 17);
grid on;

function dx = unicycle(t,x)

x1 = x(1); %% x-position
x2 = x(2); %% y-position
x3 = x(3); %% theta

v = 1; % control signal 1 (translational velocity)
omega = 3; % control signal 2 (angular velocity)

g1 = [cos(x3);sin(x3);0];
g2 = [0;0;1];

dx = g1*v + g2*omega; % The system model
end