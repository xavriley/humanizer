function noise(alpha=1, n=1000, seed=int(rand(1:1e6)), verbose=true)
  #  Ported to Julia by Xavier Riley 2015
  # 	% generate 1/f^alpha noise with N data points.
#     % Written by Holger Hennig (2008)
#     % Contact/feedback: holger.hen (at) gmail.com
# 	% For 0<alpha<2 the time series exhibits long-range correlations.
# 	% Input: x=noise(alpha,N);
# 	% Default: alpha=1, N=1000, mean 0 and standard deviation 1.

#     % Creates 1/f^alpha noise from inverse Fast Fourier Transformation (FFT)
#     % of 1/f power spectral density (PSD).
# 	% Steps:
# 	%	1. generate PSD with s(f)=1/f^alpha for f=0,...,1.
# 	%	2. Randomize phases
# 	%       a) Generate uniformly distributed random phases phi=0,...,2*pi
# 	%       b) y(f) = sqrt(s)*exp(i*phi), y(1) = 0; (zero mean)
# 	%	3. Symmetrize the PSD. y(N-k+2))=conj(y(k)) for k=2...N
# 	%	4. inverse FFT of y gives time series x. Note that x is real due to
# 	%	   symmetrizing the PSD (step 3).

#     % License: This work is licensed under a Creative Commons
#     %   Attribution-NonCommercial-ShareAlike 4.0 International License.

  N = int(ceil(n/2))

  f=linspace(0,1/2,N)

  s=1./f.^alpha;

  s[1] = 0

  srand(seed)

  phi = rand(1:N)*2*pi
	amp = sqrt(s)
	y = amp.*exp(1im.*phi)

  Y = [y,0,fliplr(conj(y[2:end]))]
	x = ifft(Y)
	x = x[1:N]

	x = x/std(x);
end