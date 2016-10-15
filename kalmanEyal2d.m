% function [Q_loc_estimate]=kalmanEyal2d(dataTS)

str=strcat('D:\Eyal\Research\LMP\Data\Users OR top 300\customer213.txt');
dataTS = txt2mat(str,0);
[data]=ReduceBad(dataTS);

timesecdiff=etime(dataTS(2:end,4:9),dataTS(1:end-1,4:9));
v=diff(dataTS(:,2:3),1)./timesecdiff;
vacc=sqrt(sum(v.^2,2));
timesecacc=timesecdiff(1:end-1)+timesecdiff(2:end);
u=(diff(vacc))./timesecacc;

T=1;

Q_loc_meas=[x(3:end,:),v(2:end,:)];

tkn_x = 150;  %measurement noise in the horizontal direction (x axis).
tkn_y = 150;
HexAccel_noise_mag = 1; %process noise: the variability in how fast the Hexbug is speeding up (stdv of acceleration: meters/sec^2)
%measurement noise in the horizontal direction (y axis).
Ez = [tkn_x 0; 0 tkn_y];
Ex = [(T)^4/4 0 (T)^3/2 0; ...
    0 (T)^4/4 0 (T)^3/2; ...
    (T)^3/2 0 (T)^2 0; ...
    0 (T)^3/2 0 (T)^2].*HexAccel_noise_mag^2; % Ex convert the process noise (stdv) into covariance matrix
P = Ex;
%  Define update equations in 2-D! (Coefficent matrices): A physics based model for where we expect the HEXBUG to be [state transition (state + velocity)] + [input control (acceleration)]
A = [1 0 (T) 0; 0 1 0 (T); 0 0 1 0; 0 0 0 1]; %state update matrice
B = [((T)^2/2); ((T)^2/2); (T); (T)];
C = [1 0 0 0; 0 1 0 0];  %this is our measurement function C, that we apply to the state estimate Q to get our expect next/new measurement
%                 u = 1.5; % define acceleration magnitude
Q= [x(2,1:2), v(1,:)]'; %initized state--it has two components: [position; velocity] of the Quail
Q_estimate = Q;  %x_estimate of initial location estimation of where the Quail is (what we are updating)
%                 NinjaVision_noise_mag = 500;  %measurement noise: How mask-blinded is the Ninja (stdv of location, in meters)
%                 QuailAccel_noise_mag = NinjaVision_noise_mag; %process noise: the variability in how fast the Quail is speeding up (stdv of acceleration: meters/sec^2)

%                 Ez = NinjaVision_noise_mag^2;% Ez convert the measurement noise (stdv) into covariance matrix
%                 Ex = QuailAccel_noise_mag^2 * [T^4/4 T^3/2; T^3/2 T^2]; % Ex convert the process noise (stdv) into covariance matrix
%                 P = Ex; % estimate of initial Quail position variance (covariance matrix)

%  Do kalman filtering
%initize estimation variables
Q_loc_estimate = []; %  Quail position estimate
vel_estimate = []; % Quail velocity estimate
%                 Q= [0; 0]; % re-initized state
P_estimate = P;
P_mag_estimate = [];
predic_state = [];
predic_var = [];
%                 for t = 1:length(Q_loc)
for tK = 1:size(Q_loc_meas,1)
    % Predict next state of the quail with the last state and predicted motion.
    %                     Q_estimate = A * Q_estimate + B * u(tK)+QuailAccel_noise_mag*randn;
    Q_estimate = A * Q_estimate + B* u(tK);
    predic_state = [predic_state; round(Q_estimate(1:2)')] ;
    %predict next covariance
    P = A * P * A' + Ex;
    predic_var = [predic_var; P] ;
    % predicted Ninja measurement covariance
    % Kalman Gain
    K = P*C'*inv(C*P*C'+Ez);
    % Update the state estimate.
    Q_estimate = Q_estimate + K * (Q_loc_meas(tK,1:2)' - C * Q_estimate);
    % update covariance estimation.
    P =  (eye(4)-K*C)*P;
    %Store for plotting
    Q_loc_estimate = [Q_loc_estimate; round(Q_estimate(1:2,1))'];
    vel_estimate = [vel_estimate; Q_estimate(3:4)'];
    P_mag_estimate = [P_mag_estimate; P(1,1),P(2,2)];
end
% Plot the results
% figure
% %                 tt = 0 : T : duration;
% plot(t(3:end),Q_loc_meas(1:end,1),'-k.', t(3:end),predic_state(:,1),'-g.');
% legend('Measuare','Kalman');
% figure
% %                 tt = 0 : T : duration;
% plot(t(3:end),Q_loc_meas(1:end,2),'-k.', t(3:end),predic_state(:,2),'-g.');
% legend('Measuare','Kalman');
% end

