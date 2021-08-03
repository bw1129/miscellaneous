% SQLite Matlab Interface
classdef SQLite < handle
    properties (GetAccess='public', SetAccess='public') % Theoretically Its Acting Up Right Now
        testProp; % This is public, you can access it outside as well
    end
    properties (GetAccess='private', SetAccess='private')
        ProgramPath_; % these are private they can only be accessed internally
        dbPath_;
        debug = false;
    end
    methods
        % Constructor
        function self = SQLite (ProgramPath)
            self.ProgramPath_ = ProgramPath;
        end
        
        function out = enableDebug (self)
            self.debug = ~self.debug;
            out = self;
        end

        function [status, cmdout] = callProgram (self, data)
            cmmnd = ['"' self.ProgramPath_ '"' data];
            [status, cmdout] = system(cmmnd);

            if (self.debug == true)
                if (isempty(cmdout) == 1)
                    cmdoutD = "NULL";
                else
                    cmdoutD = cmdout;
                    cmdoutD = ['[' regexprep(cmdoutD,'\r\n?|\n',',') ']'];
                end
                printf("Cmmnd: [Status: %d, CMDout: %s]\n", status, cmdoutD);
            end
        end

        function out = importCSV (self, csvPath, table)
            csvPath = ['"' csvPath '"'];

            sqlImportCommand = self.VECIN(
                ' ', self.dbPath_,
                ' -cmd ',
                '".mode csv" ',
                '".import ', csvPath, ' ', table, '" ',
                '"delete from ', table, ' where ROWID == 1;"'
            );
            
            out = self.callProgram(sqlImportCommand);
        end
        
        function out = openDB (self, dbPath)
            self.dbPath_ = ['"' dbPath '"'];
            
            % OpenDB or Create DB if it doesn't exist
            cmmnd = [' ' self.dbPath_ ' ".exit"'];
            [status, cmdout] = self.callProgram(cmmnd); % [status, cmdout]
            
            out = self;
        end
        
        function out = closeDB (self) % unimplemented
            %self.dbPath_ = null;
            out = self;
        end
        
        function out = queryS (self, Query)

            % OpenDB or Create DB if it doesn't exist
            cmmnd = [' ' self.dbPath_ ' "' Query '"'];
            [status, cmdout] = self.callProgram(cmmnd); % [status, cmdout]

            out = cmdout;
        end
        
        % testProp Setter and Getter
        function set.testProp (self,newVal)
            self.testProp = newVal;
        end
        function ret = get.testProp (self)
            printf("get TestProp : %s", self.testProp);
            ret = self.testProp;
        end
        
        % Test Func
        function out = test ()
            out = 25;
        end
        
        % Overridden disp func
        function str = disp (self)
            str=sprintf('REE:"%s"', self.testProp);
        end

        % Variadic in and out Remember this:
        function out = VINOUT(varargin)
            printf("Number of input arguments: %d\n", nargin);
            out = ZARRAY();
            vsize = nargin-1;
            for i = 2:nargin
                printf("%d", varargin{i});
                out.set(i-1, varargin{i});
                if(i != nargin)
                    printf(",");
                else
                    printf("\n");
                end
            end
        end

        function out = VECORG(self, data)
            dsize = size(data)(2);
            
            Query = "";
            for i = 1:dsize
                Query = [Query data{i}];
            end

            out = Query;
        end

        function out = VECIN(self, varargin)
            if self.debug == true
                printf("Number of input arguments: %d\n", nargin);
            end
            
            Query = self.VECORG(varargin);

            if self.debug == true
                printf("%s\n", Query);
            end

            out = Query;
        end

        function out = query(self, varargin)
            Query = self.VECORG(varargin);

            % OpenDB or Create DB if it doesn't exist
            cmmnd = [' ' self.dbPath_ ' "' Query '"'];
            [status, cmdout] = self.callProgram(cmmnd); % [status, cmdout]

            out = cmdout;

        end
        
    end
end