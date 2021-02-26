# MatDSP
Matlab functions to use for Digital Signal Processing.
# How To Use
Sequence.m & conv_rt.m must be placed in the current directory to use the functions within them.
# sequence(data, offset)
	data: sequence of numbers.
	offset: offset of the first element of the sequence.
# flip(x) 
        flip the sequence so that y = x[-n]. Offset is manipulated as well.
# shift(x, n0)  
        y[n] = x[n - n0]
# plus(x, y)  
        x + y
# minus(x, y)  
        x - y
# times(x, y)  
        x * y
# stem(x)  
        STEM Display a Matlab sequence, x, using a stem plot.
# conv(x, y)
        Convolution of x and y sequences.
# deconv(y,h)
        Deconvolution of x an y sequences.
