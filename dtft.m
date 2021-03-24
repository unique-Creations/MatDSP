function y = dtft(x, w)
            X = zeros(1,length(w)); % Initialize $$ X(\omega) $$
            Q = (x.offset : x.offset + length(x.data)-1)' * w; % $$Q = \omega n $$
            X = x.data  *  exp(-1j*Q); % $$ X(\omega)=x[n]e^(-j \omega n) $$
           y = X; 
        end
     