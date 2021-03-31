classdef sequence
    properties
        data
        offset
    end
    
    methods
        function s = sequence(data, offset)
            % SEQUENCE   Sequence object
            %            S = SEQUENCE(DATA, OFFSET) creates sequence S
            %            using DATA and OFFSET
            %            Ernesto Ruiz  26 Jan 2021
            s.data = data;
            s.offset = offset;
        end
        
        function display(s)
            var = inputname(1);
            if (isempty(var))
                disp('ans =');
            else
                disp([var '=']);
            end
            switch length(s.data)
                case 0
                    disp('    data: []')
                case 1
                    disp(['    data: ', num2str(s.data)])
                otherwise
                    disp(['    data: [' num2str(s.data) ']'])
            end
            disp(['  offset: ' num2str(s.offset)])
        end
        
        function y = flip(x)
            % FLIP Flip a Matlab sequence structure, x, so y = x[-n]
            f = [x.data(end:-1:1)];
            y = sequence(f,-(x.offset+length(x.data)-1)); %calculate the x value of the first element of the matrix
            return
        end
        
        function y = shift(x, n0)
            % SHIFT Shift a Matlab sequence structure, x, by integer amount n0 so that y[n] = x[n - n0]
            y = sequence(x.data,x.offset+n0);%shift right or left depending on the sign of n0
        end
        
        function z = plus(x, y)
            % PLUS  Add x and y. Either x and y will both be sequence structures, or one of them may be a number.
            if isa(x, 'sequence') == 0 %If x or y = int; iterate matrix; add int to each
                result = y.data + x;
                z = sequence(result,y.offset);
                return;
            elseif isa(y, 'sequence') == 0
                result = x.data + y;
                z = sequence(result,x.offset);
                return;
            end
            sizex = [zeros(1,x.offset-y.offset) x.data]; %line 60 & 61 fills matrix with zeros to match the lengths,
            sizey = [zeros(1,y.offset-x.offset) y.data]; %if x.offset-y.offset or vice versa results in a negative, matrix will remain the same size.
            resultx2 = (length(x.data) + x.offset) -1;
            resulty2 = (length(y.data) + y.offset) -1;
            resultx = [sizex zeros(1 ,resulty2-resultx2)];%line 62 & 63 create matrix of resulting x & y depending on which is larger.
            resulty = [sizey zeros(1 ,resultx2-resulty2)];
            z = sequence([resultx + resulty], min(x.offset, y.offset)); %create sequence with the operation required ;return min offset; return result
        end
        
        function z = minus(x, y)
            if isa(x, 'sequence') == 0 %If x or y = int; iterate matrix; subtract int to each
                result = x - y.data;
                z = sequence(result,y.offset);
                return;
            elseif isa(y, 'sequence') == 0
                result = x.data - y;
                z = sequence(result,x.offset);
                return;
            end
            resultx = [zeros(1,x.offset-y.offset) x.data];
            resulty = [zeros(1,y.offset-x.offset) y.data];
            resultx2 = (length(x.data) + x.offset) -1;
            resulty2 = (length(y.data) + y.offset) -1;
            sizex = [resultx zeros(1 ,resulty2-resultx2)];
            sizey = [resulty zeros(1 ,resultx2-resulty2)];
            z = sequence((sizex - sizey), min(x.offset, y.offset));
        end
        function z = times(x, y)
            if isa(x, 'sequence') == 0 %If x or y = int; iterate matrix; multiply int to each
                result = y.data * x;
                z = sequence(result,y.offset);
                return;
            elseif isa(y, 'sequence') == 0
                result = x.data * y;
                z = sequence(result,x.offset);
                return;
            end
            resultx = [zeros(1,x.offset-y.offset) x.data];
            resulty = [zeros(1,y.offset-x.offset) y.data];
            resultx2 = (length(x.data) + x.offset) -1;
            resulty2 = (length(y.data) + y.offset) -1;
            sizex = [resultx zeros(1 ,resulty2-resultx2)];
            sizey = [resulty zeros(1 ,resultx2-resulty2)];
            z = sequence((sizex .* sizey), min(x.offset, y.offset));
        end
        
        function stem(x)
            % STEM Display a Matlab sequence, x, using a stem plot.
            n = x.offset + (0:length(x.data)-1); %adding the offset to the length of the matrix displays only the relevant values
            stem(n,x.data)
        end
        function y = conv(x, h)
            % CONV Convolve two finite-length MatLab sequence objects, x
            % and h. RETURN sequence object, y.
            lengthy = length(x.data)+length(h.data)-1;
            yo = x.offset+h.offset;
            if length(x.data) < length(h.data) % if x is smaller than h else
                mtx = zeros(length(x.data), lengthy); %Create matrix needed for toeplit matrix
                for i = 1:length(x.data)
                    mtx(i , i : (length(h.data)+(i-1))) = h.data; %Add h sequence to toeplitz matrix
                    result = x.data * mtx;
                end
                y = sequence(result,yo);
                return;
            else
                mtx = zeros(length(h.data), lengthy); %Create matrix needed for toeplitz matrix
                for i = 1:length(h.data)
                    mtx(i , i : (length(x.data)+(i-1))) = x.data; %Add x sequence to toeplitz matrix
                    result = h.data * mtx;
                end
                y = sequence(result,yo);
                return;
            end
        end
        
        function x = deconv(y,h)
            lengthx = length(y.data)-length(h.data)+1; %get the length of x 
            xn = zeros(1,lengthx); %create a 1 * lengthx matrix
            xn(1,1) = y.data(1,1) / h.data(1,1); % x[0] = y[0] / h[0]
            hh = zeros(1, lengthx); %prepare a zero matrix with the length of x
            hh(1,1:length(h.data)) = h.data; %place h into the zero matrix
            for n = 2 : lengthx 
                temp = 0; 
                k = 1; 
                while (k < n) 
                    temp = temp + (xn(1,k)*hh(1,n - (k-1) )); %retrieve summation of x[k]*h[n-k] from 0 : n-1
                    k = k+1;
                end
                xn(1,n) = ( y.data(1,n) - temp ) / h.data(1,1); %x[n] = (y[n] - summation of x[k]*h[n-k] from 0 : n-1 ) / h[0]
            end
            x = sequence(xn, y.offset - h.offset);
        end
        
         function y = even(x)
            negx = flip(x); % x[-n]
            even = plus(x,negx); % x[n] + x[-n]
            xe = even.data / 2; % (x[n] + x[-n]) / 2
            y = sequence(xe,negx.offset); 
        end
        
        function y = odd(x)
            negx = flip(x); % x[-n]
            odd = minus(x,negx); % x[n] + x[-n]
            xo = odd.data / 2; % (x[n] + x[-n]) / 2
            y = sequence(xo,negx.offset); 
        end
        
        function y = trim(x)
            oldx = length(x.data);
            % Find the first nonzero index & last nonzero index
            % then trim x.data
            x.data = x.data(find(x.data,1,'first'):find(x.data,1,'last'));
            x.offset = x.offset + (oldx-length(x.data));
            y = sequence(x.data, x.offset); 
        end
        function y = conj(x)
            r = real(x.data);
            im = -imag(x.data);
            conjugate = r + (1j*im);
            y = sequence(conjugate,x.offset);
        end
    end
end
