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
            f = fliplr(x.data); %fliplr flips the values by row from left to right
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
        function z = conv(x, y)
            zero(length(x.data), length(x.data)+length(y.data)-1);
            z = sequence(x.data,y.offset);
            
        end
	end
end