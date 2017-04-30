from numpy import *

def simple_integral(func,a,b,dx = 0.001):
	return sum(map(lambda x:dx*x, func(arange(a,b,dx))))

print simple_integral(sin,0,2*pi)
