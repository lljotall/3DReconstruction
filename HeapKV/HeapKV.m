classdef HeapKV < handle
%
% Abstract superclass for all HeapKV classes
%
% Note: You cannot instantiate HeapKV objects directly; use MaxHeapKV or
%       MinHeap
%

    %
    % Protected properties
    %
    properties (Access = protected)
        k;                  % current number of elements
        n;                  % HeapKV capacity
        x;                  % HeapKV array
    end
    
    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = HeapKV(n,x0)
            % Initialize HeapKV
            if (n == 0)
                HeapKV.ZeroCapacityError();
            end
            this.n = n;
            this.x = {cell(1,n)};
            
            if ((nargin == 2) && ~isempty(x0))
                % Insert given elements
                k0 = numel(x0);
                if (k0 > n)
                    % HeapKV overflow
                    HeapKV.OverflowError();
                else
                    this.x(1:k0) = x0(:);
                    this.SetLength(k0);
                end
            else
                % Empty HeapKV
                this.Clear();
            end
        end
        
        %
        % Return number of elements in HeapKV
        %
        function count = Count(this)
            %-------------------------- Count -----------------------------
            % Syntax:       count = H.Count();
            %               
            % Outputs:      count is the number of values in H
            %               
            % Description:  Returns the number of values in H
            %--------------------------------------------------------------
            
            count = this.k;
        end
        
        %
        % Return HeapKV capacity
        %
        function capacity = Capacity(this)
            %------------------------- Capacity ---------------------------
            % Syntax:       capacity = H.Capacity();
            %               
            % Outputs:      capacity is the size of H
            %               
            % Description:  Returns the maximum number of values that can 
            %               fit in H
            %--------------------------------------------------------------
            
            capacity = this.n;
        end
        
        %
        % Check for empty HeapKV
        %
        function bool = IsEmpty(this)
            %------------------------- IsEmpty ----------------------------
            % Syntax:       bool = H.IsEmpty();
            %               
            % Outputs:      bool = {true,false}
            %               
            % Description:  Determines if H is empty
            %--------------------------------------------------------------
            
            if (this.k == 0)
                bool = true;
            else
                bool = false;
            end
        end
        
        %
        % Check for full HeapKV
        %
        function bool = IsFull(this)
            %-------------------------- IsFull ----------------------------
            % Syntax:       bool = H.IsFull();
            %               
            % Outputs:      bool = {true,false}
            %               
            % Description:  Determines if H is full
            %--------------------------------------------------------------
            
            if (this.k == this.n)
                bool = true;
            else
                bool = false;
            end
        end
        
        %
        % Clear the HeapKV
        %
        function Clear(this)
            %-------------------------- Clear -----------------------------
            % Syntax:       H.Clear();
            %               
            % Description:  Removes all values from H
            %--------------------------------------------------------------
            
            this.SetLength(0);
        end
    end
    
    %
    % Abstract methods
    %
    methods (Abstract)
        %
        % Sort elements
        %
        Sort(this);
        
        %
        % Insert key
        %
        InsertKey(this,key);
    end
    
    %
    % Protected methods
    %
    methods (Access = protected)
        %
        % Swap elements
        %
        function Swap(this,i,j)
            val = this.x{i};
            this.x{i} = this.x{j};
            this.x{j} = val;
        end
        
        %
        % Set length
        %
        function SetLength(this,k)
            if (k < 0)
                HeapKV.UnderflowError();
            elseif (k > this.n)
                HeapKV.OverflowError();
            end
            this.k = k;
        end
    end
    
    %
    % Protected static methods
    %
    methods (Access = protected, Static = true)
        %
        % Parent node
        %
        function p = parent(i)
            p = floor(i / 2);
        end
        
        %
        % Left child node
        %
        function l = left(i)
            l = 2 * i;
        end
        
        % Right child node
        function r = right(i)
            r = 2 * i + 1;
        end
        
        %
        % Overflow error
        %
        function OverflowError()
            error('HeapKV overflow');
        end
        
        %
        % Underflow error
        %
        function UnderflowError()
            error('HeapKV underflow');
        end
        
        %
        % No capacity error
        %
        function ZeroCapacityError()
            error('HeapKV with no capacity is not allowed');
        end
    end
end
