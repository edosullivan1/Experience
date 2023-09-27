clear all; close all;
%Read Raw Data
M2_Data = readtable('M2_Data.csv');
M4_Data = readtable('M4_Data.csv');

%PART (A)
%Find missing timepoints using find function
%Where the difference between consecutive timepoints is more than 1 hour
%To verify that table2timetable function is working
idx_M2 = find(diff(M2_Data.time) > 1/24);
datestr(M2_Data.time(idx_M2));

idx_M4 = find(diff(M4_Data.time) > 1/24);
datestr(M4_Data.time(idx_M4));

%Convert table to timetable and add each missing timepoint
%There should now be 8761 timepoints (there is)
M2_tt_data = table2timetable(M2_Data, 'RowTimes', 'time');
M2_tt_data = retime(M2_tt_data, 'regular', 'TimeStep', hours(1));  %default option is fillwithmissing

M4_tt_data = table2timetable(M4_Data, 'RowTimes', 'time');
M4_tt_data = retime(M4_tt_data, 'regular', 'TimeStep', hours(1));  %default option is fillwithmissing

%Create Weekly Average Timetable (Sun - Sat)
M2_tt_weekly = M2_tt_data(:,'WindSpeed');
M2_tt_weekly = retime(M2_tt_weekly, "weekly", "mean");

M4_tt_weekly = M4_tt_data(:,'WindSpeed');
M4_tt_weekly = retime(M4_tt_weekly, "weekly", "mean");

%PART (B)
%Calculate mean wind speed and standard deviation at M2 and M4
%M2_mean_windspeed = nanmean(M2_tt_data.WindSpeed);
%M4_mean_windspeed = nanmean(M4_tt_data.WindSpeed);

M2_mean_windspeed = nanmean(M2_tt_data{:,"WindSpeed"});
M4_mean_windspeed = nanmean(M4_tt_data{:,"WindSpeed"});

M2_std_windspeed = nanstd(M2_tt_data{:,"WindSpeed"});
M4_std_windspeed = nanstd(M4_tt_data{:,"WindSpeed"});

%Perform a detailed statistical analysis of the data using the method of bins. 
%Plot the resulting probability density function of the wind speed at each site.
interval = 2;
max_speed = 44;
nbins = max_speed/interval;

%Weibull Fit
M2_weibull_data = M2_tt_data(~isnan(M2_tt_data{:, 'WindSpeed'}),:);
M2_weibull_data = M2_weibull_data.WindSpeed;
M2_weibull_data = nonzeros(M2_weibull_data);
M2_weibull_parameters = wblfit(M2_weibull_data);
c_M2 = M2_weibull_parameters(1); %scale
k_M2 = M2_weibull_parameters(2); %shape

M4_weibull_data = M4_tt_data(~isnan(M4_tt_data{:, 'WindSpeed'}),:);
M4_weibull_data = M4_weibull_data.WindSpeed;
M4_weibull_data = nonzeros(M4_weibull_data);
M4_weibull_parameters = wblfit(M4_weibull_data);
c_M4 = M4_weibull_parameters(1); %scale
k_M4 = M4_weibull_parameters(2); %shape

% Wind Resource W/m^2, associated with each site
density = 1.225;
u_c_M2 = (2 * M2_mean_windspeed)/sqrt(pi);
P_w_M2 = (2/9) * sqrt(pi) * density * u_c_M2^3;

u_c_M4 = (2 * M4_mean_windspeed)/sqrt(pi);
P_w_M4 = (2/9) * sqrt(pi) * density * u_c_M4^3;


newYlabels= ["Wind Speed (knots)"];

figure(1)
stackedplot(M2_tt_data.time, M2_tt_data.WindSpeed, "DisplayLabels", newYlabels)
title('Wind Speed for M2 during 2015')
xlabel('Time')

figure(2)
stackedplot(M4_Data.time, M4_Data.WindSpeed, "DisplayLabels", newYlabels)
title('Wind Speed for M4 during 2015')
xlabel('Time')

figure (3)
stackedplot(M2_tt_weekly.time,M2_tt_weekly.WindSpeed, "DisplayLabels", newYlabels)
title('Average Weekly Wind Speed for 2015 (M2)')
xlabel('Time (Weekly Average)')

figure (4)
stackedplot(M4_tt_weekly.time,M4_tt_weekly.WindSpeed, "DisplayLabels", newYlabels)
title('Average Weekly Wind Speed for 2015 (M4)')
xlabel('Time (Weekly Average)')

figure(5)
h1 = histogram(M2_tt_data{:,"WindSpeed"},'Normalization','pdf')
hold on
y_M2 = 0:interval:max_speed;
f_M2 = exp(-(y_M2-M2_mean_windspeed).^2./(2*M2_std_windspeed^2))./(M2_std_windspeed*sqrt(2*pi));
plot(y_M2,f_M2,'LineWidth',1.5)
title('Probability Density Function for M2 Windspeed')
xlabel('Wind speed (knots)')
ylabel('Probability density')

figure(6)
h2 = histogram(M4_tt_data{:,"WindSpeed"},'Normalization','pdf','FaceColor','[0.9290 0.6940 0.1250]')
hold on
y_M4 = 0:interval:max_speed;
f_M4 = exp(-(y_M2-M4_mean_windspeed).^2./(2*M4_std_windspeed^2))./(M4_std_windspeed*sqrt(2*pi));
plot(y_M4,f_M4,'LineWidth',1.5)
title('Probability Density Function for M4 Windspeed')
xlabel('Wind speed (knots)')
ylabel('Probability density')

figure(7)
u_weibull_M2 = 0:interval:max_speed;
f_weibull_m2 = (k_M2/c_M2).*((u_weibull_M2/c_M2).^(k_M2-1)).*exp(-(u_weibull_M2/c_M2).^k_M2);
plot(u_weibull_M2, f_weibull_m2)
title("M2 Weibull Distribution k = " + k_M2 + ", c = " + c_M2)
xlabel('Wind speed (knots)')
ylabel('Probability density')

figure(8)
u_weibull_M4 = 0:interval:max_speed;
f_weibull_m4 = (k_M4/c_M4).*((u_weibull_M4/c_M4).^(k_M4-1)).*exp(-(u_weibull_M4/c_M4).^k_M4);
plot(u_weibull_M4, f_weibull_m4)
title("M4 Weibull Distribution: k = " + k_M4 + ", c = " + c_M4)
xlabel('Wind speed (knots)')
ylabel('Probability density')

figure(9)
u_rayleigh_M2 = 0:interval:max_speed;
f_rayleigh_M2 = (pi/2).*(u_rayleigh_M2/M2_mean_windspeed).*exp(-(pi/4).*(u_rayleigh_M2/M2_mean_windspeed).^2);
plot(u_rayleigh_M2, f_rayleigh_M2)
title("M2 Rayleigh Distribution")
xlabel('Wind speed (knots)')
ylabel('Probability density')

figure(10)
u_rayleigh_M4 = 0:interval:max_speed;
f_rayleigh_M4 = (pi/2).*(u_rayleigh_M4/M4_mean_windspeed).*exp(-(pi/4).*(u_rayleigh_M4/M4_mean_windspeed).^2);
plot(u_rayleigh_M4, f_rayleigh_M4)
title("M4 Rayleigh Distribution" )
xlabel('Wind speed ((knots))')
ylabel('Probability density')

figure(11)
plot(y_M2,f_M2,'LineWidth',1.5, 'Color', 'r')
hold on
plot(y_M4,f_M4,'LineWidth',1.5, 'Color', 'b')
title("M2, M4 Weibull Distribution" )
xlabel('Wind speed ((knots))')
ylabel('Probability density')
legend('M2', 'M4')

figure(12)
plot(u_rayleigh_M2, f_rayleigh_M2,'LineWidth',1.5, 'Color', 'r')
hold on
plot(u_rayleigh_M4, f_rayleigh_M4,'LineWidth',1.5, 'Color', 'b')
title("M2, M4 Rayleigh Distribution" )
xlabel('Wind speed ((knots))')
ylabel('Probability density')
legend('M2', 'M4')
