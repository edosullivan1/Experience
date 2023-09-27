close all; clear all;

global m_foot_L m_leg_L m_thigh_L m_pelvis_L m_arm_L m_torso ...
    m_foot_R m_leg_R m_thigh_R m_pelvis_R m_arm_R m_pelvis m_head_neck ...
    m_torso_arms g_x g_y g_z m_total head_scale num_rows ... 
    foot_L_cg_x foot_L_cg_y foot_L_cg_z leg_L_cg_x leg_L_cg_y leg_L_cg_z ...
    thigh_L_cg_x thigh_L_cg_y thigh_L_cg_z arm_L_cg_x arm_L_cg_y arm_L_cg_z...
    torso_L_cg_x torso_L_cg_y torso_L_cg_z pelvis_L_cg_x pelvis_L_cg_y ...
    pelvis_L_cg_z torso_cg_x torso_cg_y torso_cg_z torso_R_cg_x torso_R_cg_y...
    torso_R_cg_z head_neck_cg_x head_neck_cg_y head_neck_cg_z foot_R_cg_x...
    foot_R_cg_y foot_R_cg_z leg_R_cg_x leg_R_cg_y leg_R_cg_z thigh_R_cg_x ...
    thigh_R_cg_y thigh_R_cg_z arm_R_cg_x arm_R_cg_y arm_R_cg_z pelvis_R_cg_x...
    pelvis_R_cg_y pelvis_R_cg_z r_1_L_x r_1_R_x r_1_L_y r_1_L_z r_1_R_y r_1_R_z r_2_L_x r_2_L_y r_2_L_z r_2_R_x r_2_R_y r_2_R_z...
    r_3_L_x r_3_L_y r_3_L_z r_3_R_x r_3_R_y r_3_R_z r_4_L_x r_4_L_y r_4_L_z...
    r_4_R_x r_4_R_y r_4_R_z r_5_L_x r_5_L_y r_5_L_z r_5_R_x r_5_R_y r_5_R_z...
    r_6_L_x r_6_L_y r_6_L_z r_6_R_x r_6_R_y r_6_R_z r_7_L_x r_7_L_y r_7_L_z ...
    r_7_R_x r_7_R_y r_7_R_z r_8_x r_8_y r_8_z r_9_x r_9_y r_9_z r_10_x r_10_y r_10_z


%USING NEWTON-EULER MECHANICS
%https://www.mdpi.com/1424-8220/15/5/11258/htm#b17-sensors-15-11258

%24-27 seconds deep squat
pos = csvread('VICON_MASTER.csv',4808,0,'A4809..AII5409');

%GRF = csvread('VICON_MASTER.csv',38863,0,'A38864..N41864');
%GRFz_L = GRF(:,4);
%GRFz_R = GRF(:,10);
%10-13 seconds deep squat
%pos = csvread('VICON_MASTER.csv',2008,0,'A2009..AII2609');
Vicon_Moment = readmatrix('VICON_MOMENT_MAG_KG_ADJUSTED.xlsx','Range','A4:AG604');


% Remember that these parameters are zero-based, 
% so that column A maps to 0 and row 252 maps to 251.
t = pos(:, 1);

Ax = pos(:, 101); Ay = pos(:, 102); Az = pos(:, 103);   %Left Toe
Bx = pos(:, 380); By = pos(:, 381); Bz = pos(:, 382);   %Left Ankle
Cx = pos(:, 368); Cy = pos(:, 369); Cz = pos(:, 370);   %Left Knee
Dx = pos(:, 377); Dy = pos(:, 378); Dz = pos(:, 379);   %Left Hip
Ex = pos(:, 521); Ey = pos(:, 522); Ez = pos(:, 523);   %Left Shoulder

Fx = pos(:, 14); Fy = pos(:, 15); Fz = pos(:, 16);    %Neck
Gx = pos(:, 464); Gy = pos(:, 465); Gz = pos(:, 466);    %Head

Hx = pos(:, 125); Hy = pos(:, 126); Hz = pos(:, 127);   %Right Toe
Ix = pos(:, 428); Iy = pos(:, 429); Iz = pos(:, 430);   %Right Ankle
Jx = pos(:, 416); Jy = pos(:, 417); Jz = pos(:, 418);   %Right Knee
Kx = pos(:, 425); Ky = pos(:, 426); Kz = pos(:, 427);   %Right Hip
Lx = pos(:, 557); Ly = pos(:, 558); Lz = pos(:, 559);   %Right Shoulder
Mx = pos(:, 356); My = pos(:, 357); Mz = pos(:, 358);   %Pelvis
Nx = pos(:, 524); Ny = pos(:, 525); Nz = pos(:, 526);   %Left Wrist
Ox = pos(:, 560); Oy = pos(:, 561); Oz = pos(:, 562);   %Right Wrist
Px = pos(:, 98); Py = pos(:, 99); Pz = pos(:, 100);   %Left Heel
Qx = pos(:, 122); Qy = pos(:, 123); Qz = pos(:, 124);   %Right Heel



Sx = [Ax, Bx, Cx, Dx, Ex, Nx, Ox, Fx, Lx, Kx, Mx, Gx, Hx, Ix, Jx];
Sy = [Ay, By, Cy, Dy, Ey, Ny, Mz, Fy, Ly, Ky, My, Gy, Hy, Iy, Jy];
Sz = [Az, Bz, Cz, Dz, Ez, Nz, Oz, Fz, Lz, Kz, Mz, Gz, Hz, Iz, Jz];


Vicon_t = Vicon_Moment(:,1);

M_Vicon_Hip_L = Vicon_Moment(:,17);
M_Vicon_Hip_R = Vicon_Moment(:,22);

M_Vicon_Knee_L = Vicon_Moment(:,6);
M_Vicon_Knee_R = Vicon_Moment(:,11);

M_Vicon_Ankle_L = Vicon_Moment(:,28);
M_Vicon_Ankle_R = Vicon_Moment(:,33);

m_total = 80;
L_total = 1.86;

density = 1000;
g = [0, 0, 9.81];
g_x = 0;
g_y = 0;
g_z = -9.81;

head_scale = 1.1;

% Estimates for trunk are from Plagenhoef et al., 1983 
% https://exrx.net/Kinesiology/Segments

m_foot_L  = 0.5*0.0143*m_total;
m_leg_L   = 0.5*0.0475*m_total;
m_thigh_L = 0.5*0.105*m_total;
m_pelvis_L = 0.5*0.1366*m_total;  %w/0 pelvis
m_arm_L = 0.5*0.057*m_total;

m_torso = 0.551*m_total;     %not including arms

m_foot_R  = 0.5*0.0143*m_total;
m_leg_R   = 0.5*0.0475*m_total;
m_thigh_R = 0.5*0.105*m_total;    %w/o pelvis
m_pelvis_R = 0.5*0.1366*m_total;  

m_arm_R = 0.5*0.057*m_total;

m_pelvis = 0.1366*m_total; 
m_head_neck  = 0.0826*m_total;

m_torso_arms = m_arm_R + m_arm_L + m_torso;

x0 = ones(54,1);

num_rows = height(Ax);

for i = 1:num_rows


foot_L_cg_x(i) = (Ax(i) + Bx(i))/2;
foot_L_cg_y(i) = (Ay(i) + By(i))/2;
foot_L_cg_z(i) = (Az(i) + Bz(i))/2;

leg_L_cg_x(i) =  (Bx(i) + Cx(i))/2;
leg_L_cg_y(i) =  (By(i) + Cy(i))/2;
leg_L_cg_z(i) =  (Bz(i) + Cz(i))/2;

thigh_L_cg_x(i) =  (Cx(i) + Dx(i))/2;
thigh_L_cg_y(i) =  (Cy(i) + Dy(i))/2;
thigh_L_cg_z(i) =  (Cz(i) + Dz(i))/2;

arm_L_cg_x(i) =  (Nx(i) + Ex(i))/2;
arm_L_cg_y(i) =  (Ny(i) + Ey(i))/2;
arm_L_cg_z(i) =  (Nz(i) + Ez(i))/2;

torso_L_cg_x(i) =  (Ex(i) + Dx(i))/2;
torso_L_cg_y(i) =  (Ey(i) + Dy(i))/2;
torso_L_cg_z(i) =  (Ez(i) + Dz(i))/2;

pelvis_L_cg_x(i) = (Mx(i) + Dx(i))/2;
pelvis_L_cg_y(i) =  (My(i) + Dy(i))/2;
pelvis_L_cg_z(i) =  (Mz(i) + Dz(i))/2;

torso_cg_x(i) =  (Fx(i) + Mx(i))/2;
torso_cg_y(i) =  (Fy(i) + My(i))/2;     %Middle torso
torso_cg_z(i) =  (Fz(i) + Mz(i))/2;

torso_R_cg_x(i) =  (Lx(i) + Kx(i))/2;
torso_R_cg_y(i) =  (Ly(i) + Ky(i))/2;
torso_R_cg_z(i) =  (Lz(i) + Kz(i))/2;

head_neck_cg_x(i) =  (Fx(i) + Gx(i))/2;
head_neck_cg_y(i) =  (Fy(i) + Gy(i))/2;
head_neck_cg_z(i) =  (head_scale * (Fz(i) + Gz(i)))/2;

foot_R_cg_x(i) = (Ix(i) + Hx(i))/2;
foot_R_cg_y(i) = (Iy(i) + Hy(i))/2;
foot_R_cg_z(i) = (Iz(i) + Hz(i))/2;

leg_R_cg_x(i) =  (Jx(i) + Ix(i))/2;
leg_R_cg_y(i) =  (Jy(i) + Iy(i))/2;
leg_R_cg_z(i) =  (Jz(i) + Iz(i))/2;

thigh_R_cg_x(i) =  (Kx(i) + Jx(i))/2;
thigh_R_cg_y(i) =  (Ky(i) + Jy(i))/2;
thigh_R_cg_z(i) =  (Kz(i) + Jz(i))/2;

arm_R_cg_x(i) =  (Ox(i) + Lx(i))/2;
arm_R_cg_y(i) =  (Oy(i) + Ly(i))/2;
arm_R_cg_z(i) =  (Oz(i) + Lz(i))/2;

pelvis_R_cg_x(i) = (Mx(i) + Kx(i))/2;
pelvis_R_cg_y(i) =  (My(i) + Ky(i))/2;
pelvis_R_cg_z(i) =  (Mz(i) + Kz(i))/2;


r_1_L_x(i) = foot_L_cg_x(i) - Px(i);
r_1_L_y(i) = foot_L_cg_y(i) - Py(i);
r_1_L_z(i) = foot_R_cg_z(i) - Pz(i);

r_1_R_x(i) = foot_R_cg_x(i) - Qx(i);
r_1_R_y(i) = foot_R_cg_y(i) - Qy(i);
r_1_R_z(i) = foot_R_cg_z(i) - Qz(i);

r_2_L_x(i) = foot_L_cg_x(i) - Bx(i);
r_2_L_y(i) = foot_L_cg_y(i) - By(i);
r_2_L_z(i) = foot_R_cg_z(i) - Bz(i);

r_2_R_x(i) = foot_R_cg_x(i) - Ix(i);
r_2_R_y(i) = foot_R_cg_y(i) - Iy(i);
r_2_R_z(i) = foot_R_cg_z(i) - Iz(i);

r_3_L_x(i) = leg_L_cg_x(i) - Bx(i);
r_3_L_y(i) = leg_L_cg_y(i) - By(i);
r_3_L_z(i) = leg_R_cg_z(i) - Bz(i);

r_3_R_x(i) = leg_R_cg_x(i) - Ix(i);
r_3_R_y(i) = leg_R_cg_y(i) - Iy(i);
r_3_R_z(i) = leg_R_cg_z(i) - Iz(i);

r_4_L_x(i) = leg_L_cg_x(i) - Cx(i);
r_4_L_y(i) = leg_L_cg_y(i) - Cy(i);
r_4_L_z(i) = leg_R_cg_z(i) - Cz(i);

r_4_R_x(i) = leg_R_cg_x(i) - Jx(i);
r_4_R_y(i) = leg_R_cg_y(i) - Jy(i);
r_4_R_z(i) = leg_R_cg_z(i) - Jz(i);

r_5_L_x(i) = thigh_L_cg_x(i) - Cx(i);
r_5_L_y(i) = thigh_L_cg_y(i) - Cy(i);
r_5_L_z(i) = thigh_R_cg_z(i) - Cz(i);


r_5_R_x(i) = thigh_R_cg_x(i) - Jx(i);
r_5_R_y(i) = thigh_R_cg_y(i) - Jy(i);
r_5_R_z(i) = thigh_R_cg_z(i) - Jz(i);

r_6_L_x(i) = thigh_L_cg_x(i) - Dx(i);
r_6_L_y(i) = thigh_L_cg_y(i) - Dy(i);
r_6_L_z(i) = thigh_R_cg_z(i) - Dz(i);

r_6_R_x(i) = thigh_R_cg_x(i) - Kx(i);
r_6_R_y(i) = thigh_R_cg_y(i) - Ky(i);
r_6_R_z(i) = thigh_R_cg_z(i) - Kz(i);

r_7_L_x(i) = Mx(i) - Dx(i);
r_7_L_y(i) = My(i) - Dy(i);
r_7_L_z(i) = Mz(i) - Dz(i);

r_7_R_x(i) = Mx(i) - Kx(i);
r_7_R_y(i) = My(i) - Ky(i);
r_7_R_z(i) = Mz(i) - Kz(i);

r_8_x(i) = torso_cg_x(i) - Mx(i);
r_8_y(i) = torso_cg_y(i) - My(i);
r_8_z(i) = torso_cg_z(i) - Mz(i);

r_9_x(i) = torso_cg_x(i) - Fx(i); 
r_9_y(i) = torso_cg_y(i) - Fy(i); 
r_9_z(i) = torso_cg_z(i) - Fz(i);

r_10_x(i) = head_neck_cg_x(i)- Fx(i);
r_10_y(i) = head_neck_cg_y(i)-Fy(i);
r_10_z(i) = head_neck_cg_z(i)-Fz(i);

fun = @newton_euler_lean_r1_defined; 

X = fsolve(fun,x0);

F_GRF_L_x(i) = X(1);
F_GRF_L_y(i) = X(2);
F_GRF_L_z(i) = X(3);
F_GRF_R_x(i) = X(4);
F_GRF_R_y(i) = X(5);
F_GRF_R_z(i) = X(6);
F_ANKLE_L_x(i) = X(7);
F_ANKLE_L_y(i) = X(8);
F_ANKLE_L_z(i) = X(9);
F_ANKLE_R_x(i) = X(10);
F_ANKLE_R_y(i) = X(11);
F_ANKLE_R_z(i) = X(12);
F_KNEE_L_x(i) = X(13);
F_KNEE_L_y(i) = X(14);
F_KNEE_L_z(i) = X(15);
F_KNEE_R_x(i) = X(16);
F_KNEE_R_y(i) = X(17);
F_KNEE_R_z(i) = X(18);
F_HIP_L_x(i) = X(19);
F_HIP_L_y(i) = X(20);
F_HIP_L_z(i) = X(21);
F_HIP_R_x(i) = X(22);
F_HIP_R_y(i) = X(23);
F_HIP_R_z(i) = X(24);
F_PELVIS_x(i) = X(25);
F_PELVIS_y(i) = X(26);
F_PELVIS_z(i) = X(27);
F_HEAD_NECK_x(i) = X(28);
F_HEAD_NECK_y(i) = X(29);
F_HEAD_NECK_z(i) = X(30);
M_Ankle_L_x(i) = X(31);
M_Ankle_L_y(i) = X(32);
M_Ankle_L_z(i) = X(33);
M_Ankle_R_x(i) = X(34);
M_Ankle_R_y(i) = X(35);
M_Ankle_R_z(i) = X(36);
M_Knee_L_x(i) = X(37);
M_Knee_L_y(i) = X(38);
M_Knee_L_z(i) = X(39);
M_Knee_R_x(i) = X(40);
M_Knee_R_y(i) = X(41);
M_Knee_R_z(i) = X(42);
M_Hip_L_x(i) = X(43);
M_Hip_L_y(i) = X(44);
M_Hip_L_z(i) = X(45);
M_Hip_R_x(i) = X(46);
M_Hip_R_y(i) = X(47);
M_Hip_R_z(i) = X(48);
M_Pelvis_x(i) = X(49);
M_Pelvis_y(i) = X(50);
M_Pelvis_z(i) = X(51);
M_Head_Neck_x(i) = X(52);
M_Head_Neck_y(i) = X(53);
M_Head_Neck_z(i) = X(54);
%r_1_L_x(i) = X(55);
%r_1_L_y(i) = X(56);
%r_1_R_x(i) = X(56);
%r_1_R_y(i) = X(58);



M_Hip_L_mag(i) = sqrt((M_Hip_L_x(i).^2) + (M_Hip_L_y(i).^2) + (M_Hip_L_z(i).^2));
M_Hip_R_mag(i) = sqrt((M_Hip_R_x(i).^2) + (M_Hip_R_y(i).^2) + (M_Hip_R_z(i).^2));

M_Knee_L_mag(i) = sqrt((M_Knee_L_x(i).^2) + (M_Knee_L_y(i).^2) + (M_Knee_L_z(i).^2));
M_Knee_R_mag(i) = sqrt((M_Knee_R_x(i).^2) + (M_Knee_R_y(i).^2) + (M_Knee_R_z(i).^2));

M_Ankle_L_mag(i) = sqrt((M_Ankle_L_x(i).^2) + (M_Ankle_L_y(i).^2) + (M_Ankle_L_z(i).^2));
M_Ankle_R_mag(i) = sqrt((M_Ankle_R_x(i).^2) + (M_Ankle_R_y(i).^2) + (M_Ankle_R_z(i).^2));




end




%initial guess

%     F_G r1  M_A F_A F_H M_H 





figure (1)
plot(t,M_Knee_L_mag)
title('Torque-Time plot of Left Knee')
xlabel('Time (s)')
ylabel('Torque (Nmm)')
hold on
plot(t,M_Vicon_Knee_L)

figure (2)
plot(t,M_Knee_R_mag)
title('Torque-Time plot of Right Knee')
xlabel('Time (s)')
ylabel('Torque (Nmm)')
hold on
plot(t,M_Vicon_Knee_R)

figure (3)
plot(t,M_Hip_L_mag)
title('Torque-Time plot of Left Hip')
xlabel('Time (s)')
ylabel('Torque (Nmm)')
hold on
plot(t,M_Vicon_Hip_L)

figure (4)
plot(t,M_Hip_R_mag)
title('Torque-Time plot of Right Hip')
xlabel('Time (s)')
ylabel('Torque (Nmm)')
hold on
plot(t,M_Vicon_Hip_R)

figure (5)
plot(t,M_Ankle_L_mag)
title('Torque-Time plot of Left Ankle')
xlabel('Time (s)')
ylabel('Torque (Nmm)')
hold on
plot(t,M_Vicon_Ankle_L)


figure (6)
plot(t,M_Ankle_R_mag)
title('Torque-Time plot of Right Ankle')
xlabel('Time (s)')
ylabel('Torque (Nmm)')
hold on
plot(t,M_Vicon_Ankle_R)

CGx = [foot_L_cg_x;leg_L_cg_x;thigh_L_cg_x;torso_cg_x;head_neck_cg_x;thigh_R_cg_x;leg_R_cg_x;foot_R_cg_x];
CGy = [foot_L_cg_y;leg_L_cg_y;thigh_L_cg_y;torso_cg_y;head_neck_cg_y;thigh_R_cg_y;leg_R_cg_y;foot_R_cg_y];
CGz = [foot_L_cg_z;leg_L_cg_z;thigh_L_cg_z;torso_cg_z;head_neck_cg_z;thigh_R_cg_z;leg_R_cg_z;foot_R_cg_z];


figure(7)
plot3(Sx(1,:), Sy(1,:), Sz(1,:), 'o', 'Color', 'b', 'MarkerSize',4,'MarkerFaceColor','#D9FFFF')
hold on
plot3(CGx(:,1), CGy(:,1), CGz(:,1), 'o', 'Color', 'g', 'MarkerSize',4,'MarkerFaceColor','#D9FFFF')
xlabel('x')
ylabel('y')
zlabel('z')
hold on
%quiver3(Px(1), Py(1), Pz(1), r_1_L(1,1), r_1_L(1,2), r_1_L(1,3), 'LineWidth',3, 'Color','r', 'Marker', '*', 'MarkerSize',6)
%quiver3(Bx(1), By(1), Bz(1), r_2_L(1,1), r_2_L(1,2), r_2_L(1,3), 'LineWidth',3, 'Color','g', 'Marker', '*', 'MarkerSize',6)
%quiver3(Bx(1), By(1), Bz(1), r_3_L(1,1), r_3_L(1,2), r_3_L(1,3), 'LineWidth',3, 'Color','b', 'Marker', '*', 'MarkerSize',6)
%quiver3(Cx(1), Cy(1), Cz(1), r_4_L(1,1), r_4_L(1,2), r_4_L(1,3), 'LineWidth',3, 'Color','c', 'Marker', '*', 'MarkerSize',6)
%quiver3(Cx(1), Cy(1), Cz(1), r_5_L(1,1), r_5_L(1,2), r_5_L(1,3), 'LineWidth',3, 'Color','m', 'Marker', '*', 'MarkerSize',6)
%quiver3(Dx(1), Dy(1), Dz(1), r_6_L(1,1), r_6_L(1,2), r_6_L(1,3), 'LineWidth',3, 'Color','y', 'Marker', '*', 'MarkerSize',6)
%quiver3(Dx(1), Dy(1), Dz(1), r_7_L(1,1), r_7_L(1,2), r_7_L(1,3), 'LineWidth',3, 'Color','k', 'Marker', '*', 'MarkerSize',6)
%quiver3(Qx(1), Qy(1), Qz(1), r_1_R(1,1), r_1_R(1,2), r_1_R(1,3), 'LineWidth',3, 'Color','r', 'Marker', '*', 'MarkerSize',6)
%quiver3(Ix(1), Iy(1), Iz(1), r_2_R(1,1), r_2_R(1,2), r_2_R(1,3), 'LineWidth',3, 'Color','g', 'Marker', '*', 'MarkerSize',6)
%quiver3(Ix(1), Iy(1), Iz(1), r_3_R(1,1), r_3_R(1,2), r_3_R(1,3), 'LineWidth',3, 'Color','b', 'Marker', '*', 'MarkerSize',6)
%quiver3(Jx(1), Jy(1), Jz(1), r_4_R(1,1), r_4_R(1,2), r_4_R(1,3), 'LineWidth',3, 'Color','c', 'Marker', '*', 'MarkerSize',6)
%quiver3(Jx(1), Jy(1), Jz(1), r_5_R(1,1), r_5_R(1,2), r_5_R(1,3), 'LineWidth',3, 'Color','m', 'Marker', '*', 'MarkerSize',6)
%quiver3(Kx(1), Ky(1), Kz(1), r_6_R(1,1), r_6_R(1,2), r_6_R(1,3), 'LineWidth',3, 'Color','y', 'Marker', '*', 'MarkerSize',6)
%quiver3(Kx(1), Ky(1), Kz(1), r_7_R(1,1), r_7_R(1,2), r_7_R(1,3), 'LineWidth',3, 'Color','k', 'Marker', '*', 'MarkerSize',6)
%quiver3(Mx(1), My(1), Mz(1), r_8(1,1), r_8(1,2), r_8(1,3), 'LineWidth',3, 'Color','b', 'Marker', '*', 'MarkerSize',6)
%quiver3(Fx(1), Fy(1), Fz(1), r_9(1,1), r_9(1,2), r_9(1,3), 'LineWidth',3, 'Color','g', 'Marker', '*', 'MarkerSize',6)
%quiver3(Fx(1), Fy(1), Fz(1), r_10(1,1), r_10(1,2), r_10(1,3), 'LineWidth',3, 'Color','r', 'Marker', '*', 'MarkerSize',6)

axis equal

figure(8)
plot3(Sx(200,:), Sy(200,:), Sz(200,:), 'o', 'Color', 'b', 'MarkerSize',4,'MarkerFaceColor','#D9FFFF')
hold on
plot3(CGx(:,200), CGy(:,200), CGz(:,200), 'o', 'Color', 'g', 'MarkerSize',4,'MarkerFaceColor','#D9FFFF')
xlabel('x')
ylabel('y')
zlabel('z')
hold on
%quiver3(Px(200), Py(200), Pz(200), r_1_L(200,1), r_1_L(200,2), r_1_L(200,3), 'LineWidth',3, 'Color','r', 'Marker', '*', 'MarkerSize',6)
%quiver3(Bx(200), By(200), Bz(200), r_2_L(200,1), r_2_L(200,2), r_2_L(200,3), 'LineWidth',3, 'Color','g', 'Marker', '*', 'MarkerSize',6)
%quiver3(Bx(200), By(200), Bz(200), r_3_L(200,1), r_3_L(200,2), r_3_L(200,3), 'LineWidth',3, 'Color','b', 'Marker', '*', 'MarkerSize',6)
%quiver3(Cx(200), Cy(200), Cz(200), r_4_L(200,1), r_4_L(200,2), r_4_L(200,3), 'LineWidth',3, 'Color','c', 'Marker', '*', 'MarkerSize',6)
%quiver3(Cx(200), Cy(200), Cz(200), r_5_L(200,1), r_5_L(200,2), r_5_L(200,3), 'LineWidth',3, 'Color','m', 'Marker', '*', 'MarkerSize',6)
%quiver3(Dx(200), Dy(200), Dz(200), r_6_L(200,1), r_6_L(200,2), r_6_L(200,3), 'LineWidth',3, 'Color','y', 'Marker', '*', 'MarkerSize',6)
%quiver3(Dx(200), Dy(200), Dz(200), r_7_L(200,1), r_7_L(200,2), r_7_L(200,3), 'LineWidth',3, 'Color','k', 'Marker', '*', 'MarkerSize',6)
%quiver3(Qx(200), Qy(200), Qz(200), r_1_R(200,1), r_1_R(200,2), r_1_R(200,3), 'LineWidth',3, 'Color','r', 'Marker', '*', 'MarkerSize',6)
%quiver3(Ix(200), Iy(200), Iz(200), r_2_R(200,1), r_2_R(200,2), r_2_R(200,3), 'LineWidth',3, 'Color','g', 'Marker', '*', 'MarkerSize',6)
%quiver3(Ix(200), Iy(200), Iz(200), r_3_R(200,1), r_3_R(200,2), r_3_R(200,3), 'LineWidth',3, 'Color','b', 'Marker', '*', 'MarkerSize',6)
%quiver3(Jx(200), Jy(200), Jz(200), r_4_R(200,1), r_4_R(200,2), r_4_R(200,3), 'LineWidth',3, 'Color','c', 'Marker', '*', 'MarkerSize',6)
%quiver3(Jx(200), Jy(200), Jz(200), r_5_R(200,1), r_5_R(200,2), r_5_R(200,3), 'LineWidth',3, 'Color','m', 'Marker', '*', 'MarkerSize',6)
%quiver3(Kx(200), Ky(200), Kz(200), r_6_R(200,1), r_6_R(200,2), r_6_R(200,3), 'LineWidth',3, 'Color','y', 'Marker', '*', 'MarkerSize',6)
%quiver3(Kx(200), Ky(200), Kz(200), r_7_R(200,1), r_7_R(200,2), r_7_R(200,3), 'LineWidth',3, 'Color','k', 'Marker', '*', 'MarkerSize',6)
%quiver3(Mx(200), My(200), Mz(200), r_8(200,1), r_8(200,2), r_8(200,3), 'LineWidth',3, 'Color','b', 'Marker', '*', 'MarkerSize',6)
%quiver3(Fx(200), Fy(200), Fz(200), r_9(200,1), r_9(200,2), r_9(200,3), 'LineWidth',3, 'Color','g', 'Marker', '*', 'MarkerSize',6)
%quiver3(Fx(200), Fy(200), Fz(200), r_10(200,1), r_10(200,2), r_10(200,3), 'LineWidth',3, 'Color','r', 'Marker', '*', 'MarkerSize',6)
axis equal




