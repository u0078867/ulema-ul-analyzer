 function[S] =  asscap(AC,TS,AI)
% function[S] =  asscap(AA,TS,AI)                                          
% calculation of local coordinate system of the scapula S.
% Input :   ac,ts & ai in column vectors                                      
% Output :  S = [Xs,Ys,Zs] in column vectors                                  

xs = (AC-TS) / norm(AC-TS);
zs = cross(xs,(AC-AI)); zs = zs/norm(zs);
ys = cross(zs,xs);

S = [xs,ys,zs];

