% Convolve two finite-length arrays, x and h and reutrn array y
function y = conv_rt(x,h)
     lengthy = length(x)+length(h)-1;
            if length(x) < length(h) % if x is smaller than h else
                mtx = zeros(length(x), lengthy); %Create matrix needed for toeplit matrix
                for i = 1:length(x)
                    mtx(i , i : (length(h)+(i-1))) = h; %Add h sequence to toeplit matrix
                    result = x * mtx;
                end
                y = result(1:end);
                return;
            else
                mtx = zeros(length(h), lengthy); %Create matrix needed for toeplit matrix
                for i = 1:length(h)
                    mtx(i , i : (length(x)+(i-1))) = x; %Add x sequence to toeplit matrix
                    result = h * mtx;
                end
                y = result(1:end);
                return;
            end
end
