function [N_IHA, N_IHATotal, V_IHA, S_IHA, S_IHATotal, P_W_D, P_W_DTotal, nFrame, frameUsed]=IHA_REL(G_R_P, G_p_P, G_R_D, G_p_D, frq)

%--------INTRODUCTION-------------
% Function based on DJ Veeger implementation of the IHA (Woltring, 1990).
% It assumes that the pose of the proximal and distal segment is known in a Global common SoR.
%--------INPUT--------------------
% G_R_P      [3 x 3 x nFrame]        = orientation of the proximal segment with respect to a Global SoR -> G_R_H1;
% G_p_P      [nFrame x 3]            = position of the proximal segment SoR in a Global SoR -> GH;
% G_R_D      [3 x 3 x nFrame]        = orientation of the distal segment with respect to the Global SoR -> G_R_F;
% G_p_D      [nFrame x 3]            = position of the distal segment SoR in the Global SoR -> (US+RS)/2;
%--------OUTPUT-------------------
% N_IHA      [nFrame-something x 3]  = orientation of IHA in the proxial SoR; something: num of frames discarded because the angular velocity was < 0.25 rad/s
% V_IHA      [nFrame-something]      = velocity vector along the IHA;
% S_IHA      [nFrame-something x 3]  = position of the IHA in the proxiaml SoR; is the projection of p for each instant of time along IHA;
% P_W_D      [nFrame-something x 3]  = angular velocity of the distal segment D relative to the proximal segment P
% nFrame     [1]                     = number of frame given;
% frameUsed  [nFrame-something]      = sequence of indexes effectively used for the computation;
%--------REMARKS-------------------------
% Function used internally: afgnew, to compute the derivates of R and p.
%----------------AUTHOR------------
% Andrea G. Cutti, DEIS - University of Bologna, INAIL - Prosthesis Centre (c).
% Software provided under Open Source Licence.
%----------------------------------



nFrame=size(G_R_P,3);
%I=[1 0 0;0 1 0;0 0 1];
%frq = 100; % to be changed
frameUsed=[];


%--------Computation of P_R_D and P_p_D: called simply in short R and p
for i=1:nFrame
    R(:,:,i) = (G_R_P(:,:,i))' * G_R_D(:,:,i);
    p(i,:)   =  ( (G_R_P(:,:,i))' * G_p_D(i,:)' - (G_R_P(:,:,i))' * G_p_P(i,:)' )';
end


%--------Internal reshaping of R: from [3 x 3 x nFrame]-> [nFrames x 9]
for i=1:nFrame
    R_temp(:,:,i)=R(:,:,i)';
end

R2d=reshape(R_temp,9,nFrame)';
R_temp=[];


%--------Differentiations
R2d_dot=afgnew(R2d,frq);  %[nFrame x 9]; 100 = acquisition freq (Hz)
pdot=afgnew(p,frq);  %[nFrame x 3]; 100 = acquisition freq (Hz)

j=1;
k=1;
for i=1:nFrame

    Ri = R(:,:,i);
    Ri_dot = [reshape(R2d_dot(i,:),3,3)'];
    w = 0.5*(Ri_dot*Ri'-Ri*Ri_dot');          %This is to be sure that the antisimmetric matrix which gives Wu is actually a real antisimmetric matrix
    Wu=[w(3,2);w(1,3);w(2,1)];                %[3x1]

    Vu=pdot(i,:)';                            %[3 x 1]
    Pu=p(i,:)';                               %[3 x 1]

    wu=sqrt(Wu'*Wu);

    if wu~=0 % Vs singularities
        %--------Extraction of total vel ang information
        P_W_DTotal( k,: ) = Wu';                      %[nFrame x 3]
        %--------Extraction of IHA information discarding only frames Wu
        %being null
        N_IHATotal(k,:)=( Wu / wu )';
        S_IHATotal(k,:)=( Pu + cross(Wu, Vu / (wu*wu) ) )';
        k=k+1;
    end

    if norm(Wu)>.25                           % extra limitation of a minimum rotation velocity  (.25 rad/sec)
        %       wu=sqrt(Wu'*Wu);
        Nu=Wu/wu;
        N_IHA(j,:)=Nu';
        vu=Vu'*Nu;
        Su=Pu+cross(Wu,Vu/(wu*wu));
        S_IHA(j,:)=Su';
        V_IHA(j)=vu;
        P_W_D(j,:)=Wu';
        j=j+1;
        frameUsed=[frameUsed j];
    end
end


%--------Exception: trying to run this code on a static trial or on a trial during which all frames are unaceptable -> void vector/matrices are placed as
%outputs to avoid a MATLAB error.

if isempty(frameUsed)
    warning('You are running the IHA_WOL code on a static trial or on a trial for which none of the frame are acceptable\n"')
    N_IHA=[];
    V_IHA=[];
    S_IHA=[];
    P_W_D=[];
end
