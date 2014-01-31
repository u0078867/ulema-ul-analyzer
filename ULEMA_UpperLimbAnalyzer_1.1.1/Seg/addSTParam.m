%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function out = addSTParam(paramList, points, angles, anglesEntireCycle, phase, curve, kineFreq)

for i = 1 : length(paramList)

    param = paramList{i};
    
    switch param
        case 'minValue'
            out.minValue = min(angles.(curve));
        case 'maxValue'
            out.maxValue = max(angles.(curve));
        case 'startValue'
            out.startValue = angles.(curve)(1);
        case 'endValue'
            out.endValue = angles.(curve)(end);
        case 'duration' % s
            fn = fieldnames(angles);
            out.duration = length(angles.(fn{1})) / kineFreq;
        case 'percentageTiming' % % of total time
            % if strcmp(phase,'EntireCycle')
                fn = fieldnames(angles);
                fn2 = fieldnames(anglesEntireCycle);
                out.percentageTiming = length(angles.(fn{1})) / length(anglesEntireCycle.(fn2{1})) * 100;
            % else
            %    out.percentageTiming = [];
            % end
        case {'Vmax','timeVmax'} % m/s, s
            % Calculating velocity for every direction
            velocity(:,1) = deriv(points.(curve)(:,1),0,1/kineFreq);
            velocity(:,2) = deriv(points.(curve)(:,2),0,1/kineFreq);
            velocity(:,3) = deriv(points.(curve)(:,3),0,1/kineFreq);
            % Calculating velocity module for every frame
            for t = 1 : size(velocity, 1)
                velocityModule(t) = norm(velocity(t,:)); 
            end
            switch param
                case 'Vmax'
                    out.Vmax = max(velocityModule);
                case 'timeVmax'
                    fn = fieldnames(angles);
                    Vmax = max(velocityModule);
                    VmaxFrame = find(velocityModule == Vmax,1);
                    out.timeVmax = VmaxFrame / length(angles.(fn{1})) * 100;
            end
        case 'trajectory' % adimensional: >=1
            positionDiff = diff(points.(curve));
            for t = 1 : size(positionDiff,1)
                positionDiffNorm(t,1) = norm(positionDiff(t,:));
            end
            positionDiffNorm(end+1) = positionDiffNorm(end);  
            totTraj = sum(positionDiffNorm);
            straightTraj = norm(points.(curve)(end,:) - points.(curve)(1,:));
            out.trajectory = totTraj / straightTraj; % index of curvature (>= 1)
        case 'jerk'
            % Calculating jerk
            temp = points.(curve);
            for der = 1 : 3
                temp(:,1) = deriv(temp(:,1),0,1/kineFreq);
                temp(:,2) = deriv(temp(:,2),0,1/kineFreq);
                temp(:,3) = deriv(temp(:,3),0,1/kineFreq);
            end
            temp(1:3,1:3) = NaN;
            out.jerk = temp;
    end

end

