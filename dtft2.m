function y = dtft2(x, w)
    n = (x.offset:x.offset + length(x.data)-1);
    Q = n' * w;
    dtft = x.data * exp(-1j*Q);
    
    for i = 1:length(dtft)
        magnitude = abs(dtft(i));
        theta = angle(dtft(i));
        y.real(i) = magnitude*cos(theta);
        y.imag(i) = magnitude*sin(theta);
    end
end