function plot_magph(x, w)
    n = (x.offset:x.offset + length(x.data)-1);
    Q = n' * w;
    dtft = x.data * exp(-1j*Q);
    
    for i = 1:length(dtft)
        magnitude = abs(dtft(i));
        theta = angle(dtft(i));
        y.real(i) = magnitude * cos(theta);
        y.imag(i) = magnitude * sin(theta);
    end
    
    magnitude = sqrt(((y.real).^2)+((y.imag).^2));
    phase = atan2(y.imag, y.real);
    subplot (2, 1, 1);
    plot((w/pi),magnitude);
    
    title( 'Magnitude');
    ylabel('|x(\omega)|');
    subplot (2, 1, 2);
    plot((w/pi),(phase/pi));
    
    title( 'Phase');
    xlabel('\omega(rad/\pi),');
    ylabel('\angleX(\omega)');
end