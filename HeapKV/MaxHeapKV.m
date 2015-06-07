classdef MaxHeapKV < HeapKV
%--------------------------------------------------------------------------
% Class:        MaxHeapKV < HeapKV (& handle)
%               
% Constructor:  H = MaxHeapKV(n);
%               H = MaxHeapKV(n,x0);
%               
% Properties:   (none)
%               
% Methods:                 H.InsertKey(key);
%               sx       = H.Sort();
%               max      = H.ReturnMax();
%               max      = H.ExtractMax();
%               count    = H.Count();
%               capacity = H.Capacity();
%               bool     = H.IsEmpty();
%               bool     = H.IsFull();
%                          H.Clear();
%               
% Description:  This class implements a max-heap of numeric keys
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         January 16, 2014
%
% Edited by Jose Americo - June 6, 2015
%--------------------------------------------------------------------------

    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = MaxHeapKV(varargin)
            %----------------------- Constructor --------------------------
            % Syntax:       H = MaxHeapKV(n);
            %               H = MaxHeapKV(n,x0);
            %               
            % Inputs:       n is the maximum number of keys that H can hold
            %               
            %               x0 is a vector (of length <= n) of numeric keys
            %               to insert into the heap during initialization
            %               
            % Description:  Creates a max-heap with capacity n
            %--------------------------------------------------------------
            
            % Call base class constructor
            this = this@HeapKV(varargin{:});
            
            % Construct the max heap
            this.BuildMaxHeapKV();
        end
        
        %
        % Insert key
        %
        function InsertKey(this,key)
            %------------------------ InsertKey ---------------------------
            % Syntax:       H.InsertKey(key);
            %               
            % Inputs:       key is a number
            %               
            % Description:  Inserts key into H
            %--------------------------------------------------------------
            
            this.SetLength(this.k + 1);
            this.x{this.k}{1} = -inf;
            this.IncreaseKey(this.k,key);
        end
        
        %
        % Sort the heap
        %
        function sx = Sort(this)
            %-------------------------- Sort ------------------------------
            % Syntax:       sx = H.Sort();
            %               
            % Outputs:      sx is a vector that contains the sorted
            %               (ascending order) keys in H
            %               
            % Description:  Returns the sorted values in H
            %--------------------------------------------------------------
            
            % Sort the heap
            nk = this.k; % virtual heap size during sorting procedure
            for i = this.k:-1:2
                this.Swap(1,i);
                nk = nk - 1;
                this.MaxHeapify(1,nk);
            end
            sx = this.x{1:this.k}{1};
            this.x{1:this.k} = flipud(this.x{1:this.k});
        end
        
        %
        % Return maximum element
        %
        function max = ReturnMax(this)
            %------------------------ ReturnMax ---------------------------
            % Syntax:       max = H.ReturnMax();
            %               
            % Outputs:      max is the maximum key in H
            %               
            % Description:  Returns the maximum key in H
            %--------------------------------------------------------------
            
            if (this.IsEmpty() == true)
                max = {};
            else
                max = this.x{1};
            end
        end
        
        %
        % Extract maximum element
        %
        function max = ExtractMax(this)
            %------------------------ ExtractMax --------------------------
            % Syntax:       max = H.ExtractMax();
            %               
            % Outputs:      max is the maximum key in H
            %               
            % Description:  Returns the maximum key in H and extracts it
            %               from the heap
            %--------------------------------------------------------------
            
            this.SetLength(this.k - 1);
            max = this.x{1};
            this.x{1} = this.x{this.k + 1};
            this.MaxHeapify(1);
        end
    end
    
    %
    % Private methods
    %
    methods (Access = private)
        %
        % Increase key at index i
        %
        function IncreaseKey(this,i,key)
            if (i > this.k)
                % Index overflow error
                MaxHeapKV.IndexOverflowError();
            elseif (key{1} < this.x{i}{1})
                % Increase key error
                MaxHeapKV.IncreaseKeyError();
            end
            this.x{i} = key;
            while ((i > 1) && (this.x{HeapKV.parent(i)}{1} < this.x{i}{1}))
                this.Swap(i,HeapKV.parent(i));
                i = HeapKV.parent(i);
            end
        end
        
        %
        % Build the max heap
        %
        function BuildMaxHeapKV(this)
            for i = floor(this.k / 2):-1:1
                this.MaxHeapify(i);
            end
        end
        
        %
        % Maintain the max heap property at a given node
        %
        function MaxHeapify(this,i,size)
            % Parse inputs
            if (nargin < 3)
                size = this.k;
            end
            
            ll = HeapKV.left(i);
            rr = HeapKV.right(i);
            if ((ll <= size) && (this.x{ll}{1} > this.x{i}{1}))
                largest = ll;
            else
                largest = i;
            end
            if ((rr <= size) && (this.x{rr}{1} > this.x{largest}{1}))
                largest = rr;
            end
            if (largest ~= i)
                this.Swap(i,largest);
                this.MaxHeapify(largest,size);
            end
        end
    end
    
    %
    % Private static methods
    %
    methods (Access = private, Static = true)
        %
        % Increase key error
        %
        function IncreaseKeyError()
            error('You can only increase keys in MaxHeapKV');
        end
        
        %
        % Index overflow error
        %
        function IndexOverflowError()
            error('MaxHeapKV index overflow');
        end
    end
end
