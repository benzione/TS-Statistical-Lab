clear all;
Type1={'Mean','Mode'};
Metod1={'linear','nearest'};
for user=2:2
    clearvars -except user Metod1 Type1;
    clear clc;
    close all;
    for it=1:1
        for im=1:1
            intervalT=3600;
            str=strcat({'Data\Hour'},Type1{it}...
                ,{'dataTS'},{num2str(user)});
            load(str{1});
            sH=startH(3);

            for i=0
                T=1*(2^i);
                time2sec=3600;
                t=dataTS(1,3):T:dataTS(end,3);
                [t2,it2]=setdiff(t,dataTS(:,3));
                [t3,it3]=setdiff(t,t2);

                len=length(t);
                t1=0:len-1;

        %         ts=timeseries(dataTS(:,1),dataTS(:,3));
        %         ts1 = resample(ts, t,'linear');
        %         x=floor(ts1.data);

                vq = interp1(dataTS(:,3),dataTS(:,1)...
                    ,t,Metod1{im});
                x=floor(vq);

                v=diff(x);
                u=diff(v)/2;
                Q_loc_meas=[x(3:end)',v(2:end)'];
                
                
                A = [1 T; 0 1] ; % state transition matrix:  expected flight of the Quail (state prediction)
                B = [T^2/2; T]; %input control matrix:  expected effect of the input accceleration on the state.
                C = [1 0]; % measurement matrix: the expected measurement given the predicted state (likelihood)
%                 u = 1.5; % define acceleration magnitude
                Q= [x(3); v(2)]; %initized state--it has two components: [position; velocity] of the Quail
                Q_estimate = Q;  %x_estimate of initial location estimation of where the Quail is (what we are updating)
                NinjaVision_noise_mag = 500;  %measurement noise: How mask-blinded is the Ninja (stdv of location, in meters)
                QuailAccel_noise_mag = NinjaVision_noise_mag; %process noise: the variability in how fast the Quail is speeding up (stdv of acceleration: meters/sec^2)
                
                Ez = NinjaVision_noise_mag^2;% Ez convert the measurement noise (stdv) into covariance matrix
                Ex = QuailAccel_noise_mag^2 * [T^4/4 T^3/2; T^3/2 T^2]; % Ex convert the process noise (stdv) into covariance matrix
                P = Ex; % estimate of initial Quail position variance (covariance matrix)
               
                %% Do kalman filtering
                %initize estimation variables
                Q_loc_estimate = []; %  Quail position estimate
                vel_estimate = []; % Quail velocity estimate
                Q= [0; 0]; % re-initized state
                P_estimate = P;
                P_mag_estimate = [];
                predic_state = [];
                predic_var = [];
%                 for t = 1:length(Q_loc)
                for tK = 1:size(Q_loc_meas,1)
                    % Predict next state of the quail with the last state and predicted motion.
%                     Q_estimate = A * Q_estimate + B * u(tK)+QuailAccel_noise_mag*randn;
                    Q_estimate = A * Q_estimate + B * u(tK);
                    predic_state = [predic_state; Q_estimate(1)] ;
                    %predict next covariance
                    P = A * P * A' + Ex;
                    predic_var = [predic_var; P] ;
                    % predicted Ninja measurement covariance
                    % Kalman Gain
                    K = P*C'*inv(C*P*C'+Ez);
                    % Update the state estimate.
                    Q_estimate = Q_estimate + K * (Q_loc_meas(tK,1) - C * Q_estimate);
                    % update covariance estimation.
                    P =  (eye(2)-K*C)*P;
                    %Store for plotting
                    Q_loc_estimate = [Q_loc_estimate; round(Q_estimate(1))];
                    vel_estimate = [vel_estimate; Q_estimate(2)];
                    P_mag_estimate = [P_mag_estimate; P(1)];
                end
                % Plot the results
                figure
%                 tt = 0 : dt : duration;
                plot(t(3:end),Q_loc_meas(:,1),'-k.', t(3:end),Q_loc_estimate,'-g.');
                legend('Measuare','Kalman');
            end
        end
    end
end


    