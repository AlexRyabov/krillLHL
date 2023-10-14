
function dXdt = krillLHL(t, X)
%% Deriso–Schnute + Whales as input 2 Simplified model: L (0.75)->J(0.5)->A
fa = fPeriodPulse(t, [0,              0.5,            0.75,           Params.W.t0], ...
    [Params.ActiveT, Params.ActiveT, Params.ActiveT, Params.W.ActiveT]);
fs = fa(1); %krill summer transition
fw = fa(2); %krill winter transition
fspr = fa(3); %krill winter transition
fwh = fa(4); %Whales active
%        ff = fa(4); %%Fishing active
LJTrans = Params.gamma_LJ * X(1) * fspr;
JATrans = Params.gamma_JA * X(2) * fw;
KrillBiom = [0, X(2)*Params.KrJ_wetwt_g, X(3)*Params.KrA_wetwt_g];
B = X(3); % abuandance of adults
if Params.KrGr_gamma < 0
    Params.dr =  Params.Lmax * (Params.KrGr_gamma + 1)^((-1/Params.KrGr_gamma - 1))/Params.KrGrRmax;
    LBirthRate =   Params.Lmax * B .* (1- Params.KrGr_gamma * Params.dr * B).^(1/Params.KrGr_gamma);
elseif Params.KrGr_gamma == 0
    Params.dr =  Params.Lmax * exp(-1)/Params.KrGrRmax;
    LBirthRate =   Params.Lmax * B .* exp(-Params.dr *B);
else
    error('Params.KrGr_gamma = %f, but should be less or equal than zero', Params.KrGr_gamma);
end
%         if (B>=1/Params.dr)
%             LBirthRate =  max(LBirthRate, Params.Lmin);
%         end
%Consumtion by whales and fishing
ConsW = fKW_ConsW(Params.W.Pref.*KrillBiom, fwh*Params.W.Cons* X(4), Params.W.H);
ConsW(1) = 0;  %larvae
ConsW(2) = ConsW(2)/Params.KrJ_wetwt_g;
ConsW(3)   = ConsW(3)/Params.KrA_wetwt_g;
%
% %         CurrentFishr = Params.F.Cons(round(t) - Params.F.StartYear + 1);
% %         ConsF = fKW_ConsF(Params.F.Pref.*KrillBiom, ff*CurrentFishr, Params.F.H);
% %         ConsF(1) = 0;  %larvae
% %         ConsF(2:3) = ConsF(2:3)/Params.KrJ_wetwt_g;
% %         ConsF(4)   = ConsF(4)/Params.KrA_wetwt_g;
%         %ConsF = ff *        CurrentFishr * (Params.F.Pref.*X(1:4)')/(Params.F.H + BF);  %fishery
dXdt = [(LBirthRate*fs ...
    -Params.mL*X(1)-LJTrans);... %Larvae
    ( -Params.mJ*X(2)+LJTrans-JATrans-ConsW(2)) ;... %Juveniles, premature
    ( -Params.mA*X(3)+JATrans-ConsW(3)) ;...%Juveniles mature
    ( Params.W.LG_r*(1 - X(4)/Params.W.LG_K)*X(4) )]; ...%Whales
end
