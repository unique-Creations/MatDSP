function y = mag_phase(x)
    magnitude = sqrt(((x.real).^2)+((x.imag).^2)); %magnitude of real and imaginary values
    p = zeros(1,length(x.real));
    
    for n =1:length(x.real)
        p(1,n) = atan2(x.imag(n), x.real(n));
        y.mag = magnitude;
        y.phase = p;
    end
end