% ZARRAY - Custom Matlab OOP Array
classdef ZARRAY < handle
    properties (GetAccess='private', SetAccess='private')
        array_ = []; % these are private they can only be accessed internally
        debug = false;
    end
    methods
        function self = ZARRAY(varargin) % (size, array)
            self.array_ = [];
            if nargin==2
                self.array_ = varargin{2};
            elseif nargin==1
                self.array_ = zeros(1,varargin{1});
            elseif nargin!=0
                printf("Wrong Number Of Arguments -> ZARRAY");
            end
        end
        
        function out = get(self, index)
            out = self.array_(index);
        end

        function set(self, index, val)
            self.array_(index) = val;
        end

        function out = getArray(self)
            out = self.array_;
        end

        function out = getSize(self)
            out = size(self.array_)(2);
        end

        function out = toString(self)
            formatted = "";
            for i = 1:self.getSize()
                formatted = [formatted self.get(i)]; % If numbers num2str(self.get(i)) -- Consider what to do with this.
                if (i != self.getSize())
                    formatted = [formatted ','];
                end
            end
            out = formatted;
        end

    end
end