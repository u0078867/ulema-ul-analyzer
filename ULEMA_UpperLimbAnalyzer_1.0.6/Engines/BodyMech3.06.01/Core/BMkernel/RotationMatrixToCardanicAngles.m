%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [a,b]=RotationMatrixToCardanicAngles_VECT(R,DecompositionFormat)
% ROTATIONMATRIXTOCARDANICANGLES [ BodyMech 3.06.01 ] : Rotation matrix to Cardan or Eulerian angles.
% INPUT
%   R: BODY.JOINT(jnt_id).AnatomyRefKinematics.Pose
%   DecompositionFormat: BODY.JOINT(jnt_id).AnatomyRefKinematics.DecompositionFormat
% PROCESS
%   Extracts the Cardan (or Euler) angles from a rotation matrix.
%   The  parameters  i, j, k  specify   the   sequence   of  the rotation axes 
%   (their value must be the constant (X,Y or Z). 
%   j must be different from i and k, k could be equal to i.
% OUTPUT
%   The two solutions are stored in the  three-element vectors a and b
% 
%   ORIGINAL FUNCTION: RTOCARDA (Spacelib)
%   (c) G.Legnani, C. Moiola 1998; adapted from: G.Legnani and R.Adamini 1993

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 0.1 Creation (Legnani 1998)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

i=DecompositionFormat(1);
j=DecompositionFormat(2);
k=DecompositionFormat(3);


if ( i<X | i>Z | j<X | j>Z | k<X | k>Z | i==j | j==k )
	error('Error in RTOCARDA: Illegal rotation axis ')
end

if (rem(j-i+3,3)==1)	sig=1;   % ciclic 
	else            sig=-1;  % anti ciclic
end

if (i~=k)  % Cardanic Convention
	
	a(1)= atan2(-sig*R(j,k),R(k,k));
	a(2)= asin(sig*R(i,k));
	a(3)= atan2(-sig*R(i,j),R(i,i));
	
	b(1)= atan2(sig*R(j,k),-R(k,k));
	b(2)= rem( pi-asin(sig*R(i,k)) + pi , 2*pi )-pi; 
	b(3)= atan2(sig*R(i,j),-R(i,i));


else % Euleriana Convention

	l=6-i-j;
	
	a(1)= atan2(R(j,i),-sig*R(l,i));
	a(2)= acos(R(i,i));
	a(3)= atan2(R(i,j),sig*R(i,l));

	b(1)= atan2(-R(j,i),sig*R(l,i));
	b(2)= -acos(R(i,i));
	b(3)= atan2(-R(i,j),-sig*R(i,l));

end

return
% =================================================
% END ### RotationMatrixToCardanicAngles ###
