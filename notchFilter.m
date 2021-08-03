classdef notchFilter < handle
    
    properties
        b0 = 0;
        b1 = 0;
        b2 = 0;
        a1 = 0;
        a2 = 0;
        x1 = 0;
        x2 = 0;
        y1 = 0;
        y2 = 0;
    end
    
    methods
        function update(filter, filterFreq, deltaTimeUs, Q)

            % setup variables
            omega = 2 * pi * filterFreq * deltaTimeUs * 0.000001;
            sn = sin(omega);
            cs = cos(omega);
            alpha = sn / (2 * Q);

            a0 = 1 + alpha;

            filter.b0 =  1;
            filter.b1 = -2 * cs;
            filter.b2 =  1;
            filter.a1 = -2 * cs;
            filter.a2 =  1 - alpha;

            % precompute the coefficients
            filter.b0 = filter.b0 / a0;
            filter.b1 = filter.b1 / a0;
            filter.b2 = filter.b2 / a0;
            filter.a1 = filter.a1 / a0;
            filter.a2 = filter.a2 / a0;

        end
        
        function output = apply(filter, input)

            result = filter.b0 * input + filter.b1 * filter.x1 + filter.b2 * filter.x2 - filter.a1 * filter.y1 - filter.a2 * filter.y2;

            % shift x1 to x2, input to x1
            filter.x2 = filter.x1;
            filter.x1 = input;

            % shift y1 to y2, result to y1
            filter.y2 = filter.y1;
            filter.y1 = result;

            output = result;

        end
    end
end

