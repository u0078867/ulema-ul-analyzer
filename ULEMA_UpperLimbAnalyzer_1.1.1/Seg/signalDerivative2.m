%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [outputMtx, RMSE]= signalDerivative2(inputMtx, nDerivative, method,freq)


% -------------------INTRODUZIONE----------------------
% Questa funzione calcola la derivata dei segnali di ingresso inputMtx.
% La derivata viene calcolata secondo questi criteri:
% 1)	derivata prima e seconda direttamente da f(x) con tre modalit�:
%     a.	O(h2);
%     b.	O(h4): per la derivata seconda nei punti 1, 2 e nFrame, nFrame-1 si utilizza O(h2);
%     c.	cubic spline;
% 2)	derivate di ordine superiore da f(x) mediante spline.
% 
% -------------------INPUT----------------------
% inputMtx     [ nFrame x nSignal ] = segnali di ingresso disposti per colonne;
% nDerivative  [1 x 1]        = scalare indicante l'ordine della derivata (derivata prima, seconda, terna....n-esima);
% method       [string]       = pu� assumere solo tre valori, cio� 'Oh2', 'Oh4', 'cspline';
% -------------------OUTPUT---------------------
% outputMtx    [ nFrame x nSignal ] = segnali di uscita disposti per colonne;
% RMSE         [1 x nSignal]        = questo vettore non � [] solo nel caso del metodo spline; in questo caso contiene il RMSE fra inputMtx e la spline cubica generata.
% -------------------ESEMPIO--------------------
% outputMtx = signalDerivative(inputMtx, 1, 'Oh4');
% outputMtx = signalDerivative(inputMtx, 2, 'Oh4');
% outputMtx = signalDerivative(inputMtx, 3, 'cspline');
%----------------AUTHOR------------
% Andrea G. Cutti & Pietro Garofalo, DEIS - University of Bologna, INAIL - Prosthesis Centre (c).
% Software provided under Open Source Licence.
%----------------------------------



[nFrame, nSignal] = size(inputMtx);
RMSE=[];


%Error and warining messages
if (isequal(method, 'Oh2')==0 & isequal(method, 'Oh4')==0 & isequal(method, 'cspline')==0)
    error('Derivative method not recognised, only Oh2, Oh4 and cspline are valid');
    return
end
    
if (nDerivative>2 & isequal(method,'cspline')==0)
    disp('Derivative of order higher than 2 are computed with cspline method');
end


%Code
if ( isequal(method,'cspline')==1 | nDerivative>2 )
    t=[1:1:nFrame]./freq;
    t=t';
    for i=1:nSignal
        inputMtxCS                  = csapi(t, inputMtx(:,i));                   %the number of therms of the spline depend on the specific signal dynamics
        inputMtxSP(:,i)             = fnval(inputMtxCS, t);                      %evaluate the spline in the t-specified points    
        derInputMtxCS               = fnder(inputMtxCS, nDerivative);
        outputMtx(:,i)              = fnval(derInputMtxCS, t);
    end
    RMSE(1:nSignal)                 = sqrt( sum(   ((inputMtx(:,1:nSignal)-inputMtxSP(:,1:nSignal)).^2) / (nFrame-1)   ) );
    return
end


if (isequal(method,'Oh2')==1)
    if nDerivative == 1
        outputMtx(1,:)              = -0.5.*inputMtx(3,:) + 2.*inputMtx(2,:) - (3/2).*inputMtx(1,:);
        outputMtx(2:(nFrame-1),:)   = 0.5.*inputMtx(3:nFrame,:) - 0.5.*inputMtx(1:(nFrame-2),:);
        outputMtx(nFrame,:)         =  (3/2).*inputMtx(nFrame,:) - 2.*inputMtx(nFrame-1,:) + (1/2).*inputMtx(nFrame-2,:);
        return
    end
    if nDerivative == 2 
        outputMtx(1,:)              = -inputMtx(4,:) + 4.*inputMtx(3,:) - 5.*inputMtx(2,:) + 2.*inputMtx(1,:);
        outputMtx(2:(nFrame-1),:)   = inputMtx(3:nFrame,:) - 2.*inputMtx(2:(nFrame-1),:) + inputMtx(1:(nFrame-2),:);
        outputMtx(nFrame,:)         =  2.*inputMtx(nFrame,:) - 5.*inputMtx(nFrame-1,:) + 4.*inputMtx(nFrame-2,:) - inputMtx(nFrame-3,:);
        return
    end
end


if (isequal(method,'Oh4')==1)
    if nDerivative == 1
        outputMtx(1,:)              = -0.25.*inputMtx(5,:) + (4/3).*inputMtx(4,:) - 3.*inputMtx(3,:) + 4.*inputMtx(2,:) - (25/12).*inputMtx(1,:);
        outputMtx(2,:)              = (1/12).*inputMtx(5,:) - 0.5.*inputMtx(4,:) + (3/2).*inputMtx(3,:) - (5/6).*inputMtx(2,:) - (1/4).*inputMtx(1,:);  %ok written this way!
        outputMtx(3:(nFrame-2),:)   = -(1/12).*inputMtx(5:nFrame,:) + (2/3).*inputMtx(4:(nFrame-1),:)-(2/3).*inputMtx(2:(nFrame-3),:)+ (1/12).*inputMtx(1:(nFrame-4),:);
        outputMtx(nFrame-1,:)       = -(1/12).*inputMtx(nFrame-4,:) + 0.5.*inputMtx(nFrame-3,:) - (3/2).*inputMtx(nFrame-2,:) + (5/6).*inputMtx(nFrame-1,:) + (1/4).*inputMtx(nFrame,:);  %ok written this way!
        outputMtx(nFrame,:)         =  0.25.*inputMtx(nFrame-4,:) - (4/3).*inputMtx(nFrame-3,:) + 3.*inputMtx(nFrame-2,:) - 4.*inputMtx(nFrame-1,:) + (25/12).*inputMtx(nFrame,:);
        return
    end
    if nDerivative == 2 
        %The first 2 element are the forward Oh2 and the central Oh2, as well as the last two; the central values are Oh4
        outputMtx(1,:)              = -inputMtx(4,:) + 4.*inputMtx(3,:) - 5.*inputMtx(2,:) + 2.*inputMtx(1,:);
        outputMtx(2,:)              = inputMtx(3,:) - 2.*inputMtx(2,:) + inputMtx(1,:);        
        outputMtx(3:(nFrame-2),:)   = -(1/12).*inputMtx(5:nFrame,:) + (4/3).*inputMtx(4:(nFrame-1),:)-(5/2).*inputMtx(3:(nFrame-2),:)+ (4/3).*inputMtx(2:(nFrame-3),:)- (1/12).*inputMtx(1:(nFrame-4),:);
        outputMtx(nFrame-1,:)       = inputMtx(nFrame,:) - 2.*inputMtx(nFrame-1,:) + inputMtx(nFrame-2,:);
        outputMtx(nFrame,:)         =  2.*inputMtx(nFrame,:) - 5.*inputMtx(nFrame-1,:) + 4.*inputMtx(nFrame-2,:) - inputMtx(nFrame-3,:);
        return
    
    end
end



% --------------------ECCO IL CODICE DI TEST DA RILANCIARE IN CASO DI NECESSITA':
% [der1Oh2, RMSE]= signalDerivative(anglesForearm(:,1), 1, 'Oh2');
% [der1Oh4, RMSE]= signalDerivative(anglesForearm(:,1), 1, 'Oh4');
% [der1CSPL, RMSE]= signalDerivative(anglesForearm(:,1), 1, 'cspline');
% der1Oh4RIF= deriv(anglesForearm(:,1));
% signalRMSE(der1Oh4, der1Oh4RIF)
% signalRMSE(der1Oh4, der1CSPL)
% signalRMSE(der1Oh4RIF, der1CSPL)
% signalRMSE(der1Oh2, der1CSPL)
% signalRMSE(der1Oh2, der1Oh4)
% signalRMSE(der1Oh2, der1Oh4RIF)
% [der2Oh2, RMSE]= signalDerivative(anglesForearm(:,1), 2, 'Oh2');
% [der2Oh4, RMSE]= signalDerivative(anglesForearm(:,1), 2, 'Oh4');
% [der2CSPL, RMSE]= signalDerivative(anglesForearm(:,1), 2, 'cspline');
% signalRMSE(der2Oh2, der2CSPL)
% signalRMSE(der2Oh4, der2CSPL)
% [der1Oh4Mtx, RMSE]= signalDerivative(anglesGirdle, 1, 'Oh4');
% [der1CSPLMtx, RMSE]= signalDerivative(anglesGirdle, 1, 'cspline');
% signalRMSE(der1Oh4Mtx, der1CSPLMtx) 

%------------------------RISULTATI DEL TEST DEL CODICE------------------------------------------
% >> [der1Oh2, RMSE]= signalDerivative(anglesForearm(:,1), 1, 'Oh2');
% >> [der1Oh4, RMSE]= signalDerivative(anglesForearm(:,1), 1, 'Oh4');
% >> [der1CSPL, RMSE]= signalDerivative(anglesForearm(:,1), 1, 'cspline');
% >> der1Oh4RIF= deriv(anglesForearm(:,1));
% >> signalRMSE(der1Oh4, der1Oh4RIF)
% 
% ans =
% 
%   3.2161e-015
% 
% >> signalRMSE(der1Oh4, der1CSPL)
% 
% ans =
% 
%   3.7212e-007
% 
% >> signalRMSE(der1Oh4RIF, der1CSPL)
% 
% ans =
% 
%   3.7212e-007
% 
% >> signalRMSE(der1Oh2, der1CSPL)
% 
% ans =
% 
%   9.3275e-005
% 
% >> signalRMSE(der1Oh2, der1Oh4)
% 
% ans =
% 
%   9.3141e-005
% 
% >> signalRMSE(der1Oh2, der1Oh4RIF)
% 
% ans =
% 
%   9.3141e-005
% 
% >> [der2Oh2, RMSE]= signalDerivative(anglesForearm(:,1), 2, 'Oh2');
% >> [der2Oh4, RMSE]= signalDerivative(anglesForearm(:,1), 2, 'Oh4');
% >> [der2CSPL, RMSE]= signalDerivative(anglesForearm(:,1), 2, 'cspline');
% >> signalRMSE(der2Oh2, der2CSPL)
% 
% ans =
% 
%   9.6692e-006
% 
% >> signalRMSE(der2Oh4, der2CSPL)
% 
% ans =
% 
%   5.5922e-006
% 
% >> [der2CSPL, RMSE]= signalDerivative(anglesForearm(:,1), 2, 'csplie');
% ??? Error using ==> signalderivative
% Derivative method not recognised, only Oh2, Oh4 and cspline are valid
% 
% >> [der2Oh4, RMSE]= signalDerivative(anglesForearm(:,1), 3, 'Oh4');
% Derivative of order higher than 2 are computed with cspline method
% >> [der2Oh4, RMSE]= signalDerivative(anglesForearm(:,1), 2, 'Oh4');
% >> [der3CSPL, RMSE]= signalDerivative(anglesForearm(:,1), 3, 'cspline');
% 
% >> [der1Oh4Mtx, RMSE]= signalDerivative(anglesGirdle, 1, 'Oh4');
% >> [der1CSPLMtx, RMSE]= signalDerivative(anglesGirdle, 1, 'cspline');
% >> signalRMSE(der1Oh4Mtx, der1CSPLMtx)
% 
% ans =
% 
%   1.0e-005 *
% 
%     0.0357    0.2206    0.0000
