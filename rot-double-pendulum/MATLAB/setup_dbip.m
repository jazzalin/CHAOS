%% Rotary Double Inverted Pendulum
%
% Sets the necessary parameters to run the Rotary Double Inverted Pendulum 
% laboratory using the "s_dbip" and "q_dbip" Simulink diagrams.
% 
% Copyright (C) 2012 Quanser Consulting Inc.
%
clear all;
%
%% SRV02 Configuration
% External Gear Configuration: set to 'HIGH' or 'LOW'
EXT_GEAR_CONFIG = 'HIGH';
% Encoder Type: set to 'E' or 'EHR'
ENCODER_TYPE = 'E';
% Is SRV02 equipped with Tachometer? (i.e. option T): set to 'YES' or 'NO'
TACH_OPTION = 'YES';
% Is SRV02 equipped with slip-ringt (i.e. option ETS): set to 'YES' or 'NO'
ETS_OPTION = 'NO';
% Type of Load: set to 'NONE', 'DISC', or 'BAR'
LOAD_TYPE = 'NONE';
% Amplifier Gain used: 
% VoltPAQ-X1 users: set to K_AMP to 1 and Gain switch on amplifier to 1
% VoltPAQ-X2 users: set to K_AMP 3
K_AMP = 1;
% Power Amplifier Type: set to 'VoltPAQ', 'UPM_1503', 'UPM_2405', or 'Q3'
AMP_TYPE = 'VoltPAQ';
% Digital-to-Analog Maximum Voltage (V)
VMAX_DAC = 10;
%
%% Double-Pendulum Configuration
% ROTPEN Option: 'ROTPEN' or 'ROTPEN-E'
ROTPEN_OPTION = 'ROTPEN-E';
% Define rotary arm attached to SRV02 load gear.
SRV02_ARM = 'ROTARY_ARM';
% Length of pendulums.
% Bottom 7-inch short link.
PEND_1_TYPE = 'SHORT_7IN';
% Upper 12-inch medium link.
PEND_2_TYPE = 'MEDIUM_12IN';
%
%% Safety Watchdog
% Safety watchdog on the SRV02 arm angle: ON = 1, OFF = 0 
THETA_LIM_ENABLE = 1;       % safety watchdog turned ON
% THETA_LIM_ENABLE = 0;      % safety watchdog turned OFF
% Safety Limits on the SRV02 arm angle (deg)
THETA_MAX = 90;            % pendulum angle maximum safety position (deg)
THETA_MIN = - THETA_MAX;   % pendulum angle minimum safety position (deg)
%
% Safety watchdog on pendulum 1 angle: ON = 1, OFF = 0 
ALPHA_LIM_ENABLE = 1;       % safety watchdog turned ON
% ALPHA_LIM_ENABLE = 0;      % safety watchdog turned OFF
% Safety Limits on the pendulum 1 angle (deg)
ALPHA_MAX = 45;            % pendulum angle maximum safety position (deg)
ALPHA_MIN = - ALPHA_MAX;   % pendulum angle minimum safety position (deg)
%
% Safety watchdog on pendulum 2 angle: ON = 1, OFF = 0 
GAMMA_LIM_ENABLE = 1;       % safety watchdog turned ON
%ALPHA_LIM_ENABLE = 0;      % safety watchdog turned OFF
% Safety Limits on pendulum 2 angle (deg)
%global ALPHA_MAX ALPHA_MIN
GAMMA_MAX = 25;            % pendulum angle maximum safety position (deg)
GAMMA_MIN = - GAMMA_MAX;   % pendulum angle minimum safety position (deg)
%
%% System Parameters
% Sets model variables according to the user-defined SRV02 configuration
[ Rm, kt, km, Kg, eta_g, Beq, Jm, Jeq, eta_m, K_POT, K_TACH, K_ENC, VMAX_AMP, IMAX_AMP ] = config_srv02( EXT_GEAR_CONFIG, ENCODER_TYPE, TACH_OPTION, AMP_TYPE, LOAD_TYPE );
% Load rotary arm parameters
[ g, Mr, Lr, lr, Jr, Dr ] = config_sp( 'ROTARY_ARM', 'ROTPEN-E' );
% Load medium 12-inch pendulum parameters
[ g, Mp1, Lp1, lp1, Jp1, Dp1 ] = config_sp( 'MEDIUM_12IN', 'ROTPEN-E' );
% Load short 7-inch pendulum parameters
[ g, Mp2, Lp2, lp2, Jp2, Dp2 ] = config_sp( 'SHORT_7IN', 'ROTPEN-E' );
% Mass of hinge between pendulum 1 and 2 (kg)
Mh = 0.141;
% Set Open-loop state-space model of rotary double-inverted pendulum
DBIP_ABCD_eqns;
% Initial condition used in state-space model for simulation.
X0 = [-5, 1, -0.5, 0, 0, 0] * pi / 180;
%
%% Filter Parameters
% SRV02 High-pass filter in PD control used to compute velocity
% Cutoff frequency (rad/s)
wcf_1 = 2 * pi * 50.0;
% Damping ratio
zetaf_1 = 0.9;
% Pendulum High-pass filter in PD control used to compute velocity
% Cutoff frequency (rad/s)
wcf_2 = 2 * pi * 15.0;
% Damping ratio
zetaf_2 = 0.9;
%
%% Augment the state-space system to include an integrator: zeta_dot = x
Ai = A; Bi = B;
Ai(7,1) = 1; Ai(7,7) = 0; Bi(7,1) = 0;
%
%% Controller Design         
% Integrator anti-windup parameters
INT_WDUP_MAX = 5;                % maximum integrator output voltage (V)
INT_WDUP_MIN = -5;               % minimum integrator output voltage (V)
%
Q = diag([ 1 1 1 5 1 1 0.5]);
R = 30;        
[k,S,E] = lqr(Ai,Bi,Q,R);
k