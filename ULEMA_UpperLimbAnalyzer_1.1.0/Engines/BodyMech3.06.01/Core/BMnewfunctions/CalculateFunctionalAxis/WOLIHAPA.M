function[nopt,sopt,deff,chi] = woliha(n,s)
% WOLIHAPAR return the relevant parameters of the InstantaneousHelicalAxis
%           [NOPT,SOPT,DEFF,CHI] = WOLIHAPAR(N,S) returns the estime of the mean
%           helical axis and the pivot point of the instantaneous IHA's provided
%           in input, the rms distance between the pivot point and the IHA's, and 
%           the dispersion angle of the IHA's
%           The orientation of NOPT is changed according to the mean orientations
%           of the IHAs, because the routine was enable to automatically get it (27/4/96)
% -------------------------------------------------------------------------------
% INPUT:
% n   (3xNf): unit vector of              the IHA's
% s   (3xNf): position vector of          the IHA's [mm]
% -------------------------------------------------------------------------------
% OUTPUT:
% nopt(3x 1): optimal mean helical axis orientation of the IHA's
% sopt(3x 1): optimal mean helical axis position    of the IHA's [mm]
% deff      : rms distance between sopt and            the IHA's [mm]
% chi       : dispersion angle                      of the IHA's [rad]
% -------------------------------------------------------------------------------
% Ref.: Data processing and error analysis:  Woltring HJ; pp. 203-237
%       In: Biomechanics of Human Movement (Cappozzo and Berme Ed) 1991
% Auth: A Leardini 29/1/96

Nf=size(n,2);
% --------------------- Calculating the Pivot Point: sopt -----------------------
Q=zeros(3,3);
opt=zeros(3,1); seff=0;
for i=1:Nf,
    Qi=eye(3)-n(:,i)*n(:,i)';
    Q=Q+Qi;
    opt=opt+Qi*s(:,i);
end
invn=1/Nf;
Q=invn*Q;
sopt=invn*inv(Q)*opt;

for i=1:Nf,
    Qi=eye(3)-n(:,i)*n(:,i)';
    eff=(sopt-s(:,i))'*Qi*(sopt-s(:,i));
    seff=seff+eff;
end
deff=sqrt(invn*seff);    % RMS distance between sopt and IHA's

% -------------------- Calcolating the Mean Helical Axis: nopt ----------------
[V,D]=eig(Q);
[lambda,ind]=min(diag(D));
nopt=V(:,ind);
chi=asin(sqrt(lambda));  % dispersion angle of the IHA's about nopt

% ------ Checking and Updating the direction of the Mean Helical Axis: nopt ---
if sum(nopt./mean(n')')<0
   nopt=-nopt;
end


