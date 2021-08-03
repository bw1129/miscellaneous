function filter = notchInit(filterFreq, deltaTimeUs, Q)

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
        filter.x1 = 0;
        filter.x2 = 0;
        filter.y1 = 0;
        filter.y2 = 0;
   
    end

