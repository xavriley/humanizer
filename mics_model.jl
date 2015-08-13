function mics_model(alpha=1, sigma_clock=1, len=1e3, W1=0.5, W2=W1, T=0, seed=0, alpha2=alpha, sigma_clock2=sigma_clock)
  # Translated to Julia by Xavier Riley 2015

  # This is an implementation of the Mutually Interacting Complex Systems (MICS) model.
  # The routine generates two discrete time series of intervals I1(t), I2(t).
  # Example of MICS: Two persons synchronizing musical play, then I1 are
  # the interbeat intervals (i.e., the time intervals between consecutive between beats).
  # The two time series are long-range cross-correlated (e.g., as if two musicians played toether).

  # Written by Holger Hennig (2014)
  # Contact/feedback: holger.hen (at) gmail.com
  # Based on the article: H. Hennig, PNAS 111,12974 (2014)
  # Free article download: www.nld.ds.mpg.de/~holgerh/download
  # License: This work is licensed under a Creative Commons
  #   Attribution-NonCommercial-ShareAlike 4.0 International License.

  # Input example:
  # [I1,I2,d] = mics(alpha,sigma_clock, len, W1, W2, T);
  # Optional parameters:
  #   alpha: exponent of 1/f^alpha noise (to generate clock noise). Default: alpha=1
  #   sigma_clock: relative strength of clock noise over motor noise. Default: sigma_clock=1
  #   len: length of time series. Default: len=1000
  #   W1, W2: coupling strength between the two complex systems. Default: W1=W2=0.5
  #   T: average interval. Default: T=0

  # Details. The MICS model reads
  # I_{A,n} = sigma_A C_{A,n} + T + xi_{A,n} - xi_{A,n-1}  - W_A d_{n-1}
  # I_{B,n} = sigma_B C_{B,n} + T + xi_{B,n} - xi_{B,n-1}  + W_B d_{n-1}
  # C: internal clock (source of 1/f^alpha noise)
  # xi: white noise ("motor delay", moving limbs etc.)
  # C_{A,n} and C_{B,n} are Gaussian distributed 1/f^alpha noise time series with exponent 0<alpha<2

  # internal clock noise (1/f^alpha noise)
	verbose = 0;
	C1 = sigma_clock * noise(alpha,len,seed,verbose) + T
	C2 = sigma_clock2 * noise(alpha2,len,2*seed,verbose) + T

  # motor noise (white noise)
	X1 = noise(0,len,seed,verbose)
  X2 = noise(0,len,2*seed,verbose)
  X1 = [0,X1]
  X2 = [0,X2]

  # initialize
	d = zeros(1,len+1)
	I1 = zeros(1,len)
	I2 = zeros(1,len)

	for j=1:len
    # intervals
    I1(j) = C1(j) + X1(j+1) - X1(j) - W1*d(j)
    I2(j) = C2(j) + X2(j+1) - X2(j) + W2*d(j)
		d(j+1) = d(j) + I1(j) - I2(j)
  end

	d = d(2:end);
end

# function [ I1, I2, d ] = mics_model( alpha, sigma_clock, len, W1, W2, T, seed, alpha2, sigma_clock2)
# 	% This is an implementation of the Mutually Interacting Complex Systems (MICS) model.
#     % The routine generates two discrete time series of intervals I1(t), I2(t).
#     % Example of MICS: Two persons synchronizing musical play, then I1 are
#     % the interbeat intervals (i.e., the time intervals between consecutive between beats).
#     % The two time series are long-range cross-correlated (e.g., as if two musicians played toether).
#
#     % Written by Holger Hennig (2014)
# 	% Contact/feedback: holger.hen (at) gmail.com
#     % Based on the article: H. Hennig, PNAS 111,12974 (2014)
#     % Free article download: www.nld.ds.mpg.de/~holgerh/download
#     % License: This work is licensed under a Creative Commons
#     %   Attribution-NonCommercial-ShareAlike 4.0 International License.
#
#     % Input example:
#     % [I1,I2,d] = mics(alpha,sigma_clock, len, W1, W2, T);
#     % Optional parameters:
#     %   alpha: exponent of 1/f^alpha noise (to generate clock noise). Default: alpha=1
#     %   sigma_clock: relative strength of clock noise over motor noise. Default: sigma_clock=1
#     %   len: length of time series. Default: len=1000
#     %   W1, W2: coupling strength between the two complex systems. Default: W1=W2=0.5
#     %   T: average interval. Default: T=0
#
#     % Details. The MICS model reads
#     % I_{A,n} = sigma_A C_{A,n} + T + xi_{A,n} - xi_{A,n-1}  - W_A d_{n-1}
#     % I_{B,n} = sigma_B C_{B,n} + T + xi_{B,n} - xi_{B,n-1}  + W_B d_{n-1}
#     % C: internal clock (source of 1/f^alpha noise)
# 	% xi: white noise ("motor delay", moving limbs etc.)
# 	% C_{A,n} and C_{B,n} are Gaussian distributed 1/f^alpha noise time series with exponent 0<alpha<2
#
# 	%check input
# 	if ~exist('alpha','var') || isempty(alpha), alpha=1; end
#     if ~exist('alpha2','var') || isempty(alpha2), alpha2=alpha; end
# 	if ~exist('sigma_clock','var') || isempty(sigma_clock), sigma_clock=1; end
# 	if ~exist('len','var') || isempty(len), len=1e3; end
# 	if ~exist('W1','var') || isempty(W1), W1=0.5; end
# 	if ~exist('W2','var') || isempty(W2), W2=W1; end
# 	if ~exist('T','var') || isempty(T), T=0; end
# 	if ~exist('seed','var') || isempty(seed), seed = []; end
#     if ~exist('sigma_clock2','var') || isempty(sigma_clock2), sigma_clock2=sigma_clock; end
#
# 	%internal clock noise (1/f^alpha noise)
# 	verbose = 0;
# 	C1 = sigma_clock * noise(alpha,len,seed,verbose) + T;
# 	C2 = sigma_clock2 * noise(alpha2,len,2*seed,verbose) + T;
#
# 	% motor noise (white noise)
# 	X1 = noise(0,len,seed,verbose);
#     X2 = noise(0,len,2*seed,verbose);
#     X1 = [0,X1];
#     X2 = [0,X2];
#
#     %initialize
# 	d = zeros(1,len+1);
# 	I1 =  zeros(1,len);
# 	I2 =  zeros(1,len);
#
# 	for j=1:len
#         % intervals
#         I1(j) = C1(j) + X1(j+1) - X1(j) - W1*d(j);
#         I2(j) = C2(j) + X2(j+1) - X2(j) + W2*d(j);
# 		d(j+1) = d(j) + I1(j) - I2(j);
#     end
#
# 	d = d(2:end);
#
# end