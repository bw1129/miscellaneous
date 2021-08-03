function output = notchFilterApply(filter, input)

    result = filter.b0 * input + filter.b1 * filter.x1 + filter.b2 * filter.x2 - filter.a1 * filter.y1 - filter.a2 * filter.y2;
    
    % shift x1 to x2, input to x1
    filter.x2 = filter.x1;
    filter.x1 = input;
    
    % shift y1 to y2, result to y1
    filter.y2 = filter.y1;
    filter.y1 = result;
    
    output = result;

end

