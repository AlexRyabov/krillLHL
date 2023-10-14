function fa = fPeriodPulse(t, t0, T)
%gives 1 for such t that t0-T/2 < t < t0+T/2  
%%nomalized version, integral for t=0..1 equals 1
%fa = 1./((((sin(pi * (t-t0)))/T).^10 + 1)* 0.647213719106839 * T);
%nonnormalized version, max equals 1
%fa = 1./((((sin(pi * (t-t0)))/T).^10 + 1));

%%nomalized version, integral for t=0..1 equals 1
%fa = exp(-(((sin(pi * (t-t0)))/T).^(10)))/(0.605649662804587*T);
%nonnormalized version, max equals 1
%Tf = 1.61326503459411 * T; %where  1.61326503459411= pi /(2 * asin(log(2))^(1/10))
Tf = sin(pi * T/2); %1.61326503459411 * T; %where  1.61326503459411= pi /(2 * asin(log(2))^(1/10))
fa = exp(-(sin(pi * (t-t0))./Tf).^10 * 0.693147180559945); %where 0.693147180559945 =  log(2)


%to test that the integral equals 1 you can use 
%%
% Ts = logspace(-3.5, -1, 100);
% It = [];
% tic
% for iT = 1:length(Ts)
%     fun = @(t) fPeriodPulse(t, 0.5, Ts(iT));
%     It(iT) = integral(fun,0,1);
% end
% toc
% 
% figure(1)
% semilogx(Ts, It);
return
%% to plot a sample 
t = 0:0.0001:3;
fg01 = f_MakeFigure(1, [-1, -1, 632 250])
clf
plot(t,  fPeriodPulse(t, 0.5, 0.2), 'LineWidth', 2)
hold on
plot(t,  fPeriodPulse(t, 0, 0.2), 'LineWidth', 2)
ylim([0, 1.4])
legend({'Winter, f_w(t)', 'Summer, f_w(t)'})
f_Lbls('Time, years', 'Activity')

