% Data analysis script for induction motor project
% Conor Green

clear all
close all
clc
format compact;

%%Data parsing and analysis

%Initialize arrays of the average torque values over the 1800 RPM range
avg_copper = zeros(1,1800);
avg_control = zeros(1,1800);


figure;
subplot(2,4,1);

for i=1:4
   %Read copper plated rotor data labeled "Copper_Data_1 ... Copper_Data_4"
   data = tdfread("Copper_Data_"+i); 
   speed = data.Speed_1_0x28RPM0x29;
   torque = data.Torque_1_0x28oz0x2Ein0x29;
   plot(speed,torque);
   hold on;
   
   %Parse data and fill in holes where no torque value available for that
   %RPM
   for p =1:size(speed)
      currspeed = speed(p)+1;
      currtorq = torque(p);
      if avg_copper(currspeed) == 0
          avg_copper(currspeed) = currtorq;
      else
          avg_copper(currspeed) = .5*(currtorq + avg_copper(currspeed));
        
      end
   end
   
end

%% Plotting

title("Copper-plated Rotor");
xlabel("Speed (RPM)");
ylabel("Torque (oz./in.)");
axis([0 1800 0 260]);
grid on;


sped = 0:1799;


subplot(2,4,5);
plot(sped,avg_copper);
title("Averaged Copper-plated Rotor");
xlabel("Speed (RPM)");
ylabel("Torque (oz./in.)");
grid on;
axis([0 1800 0 260]);

subplot(2,4,2);


for j = 3:10
    %Read copper plated rotor data labeled "Copper_Data_1 ... Copper_Data_4"
    data = tdfread("cont"+j);
    speed = data.Speed_1_0x28RPM0x29;
    torque = data.Torque_1_0x28oz0x2Ein0x29;
    plot(speed,torque);
    hold on;
    
    %Parse data and fill in holes where no torque value available for that
    %RPM
    for q = 1:size(speed)
       currspeed = round(speed(q)+1);
       
       currtorq = torque(q);
       if avg_control(currspeed) ==0
           avg_control(currspeed) = currtorq;
       else
           avg_control(currspeed) = .5*(currtorq + avg_control(currspeed));
    
       end
    end
end


title("Control Rotor");
xlabel("Speed (RPM)");
ylabel("Torque (oz./in.)");
grid on;
axis([0 1800 0 260]);

subplot(2,4,6);
plot(sped,avg_control);
title("Averaged Control Rotor");
xlabel("Speed (RPM)");
ylabel("Torque (oz./in.)");
grid on;
axis([0 1800 0 260]);

subplot(1,2,2);
plot(sped,avg_control);
hold on;
plot(sped, avg_copper);
title("Averaged Control and Copper Rotors");
xlabel("Speed (RPM)");
ylabel("Torque (oz./in.)");
grid on;
axis([0 1800 0 260]);
legend("Control","Copper");
hold on;

figure;
[maxtorq_cont,mt_speed_cont] = max(avg_control);
[maxtorq_cop,mt_speed_cop] = max(avg_copper);

plot(sped,avg_control);
hold on;
plot(sped,avg_copper);
hold on;
plot(mt_speed_cont*ones(261),0:260,'b');
hold on;
plot(mt_speed_cop*ones(261),0:260,'r');
title("Maximum Torque Analysis");
xlabel("Speed (RPM)");
ylabel("Torque (oz./in.)");
grid on;
axis([0 1800 0 260]);
legend("Control","Copper");



