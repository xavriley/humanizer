# Some pseudo Ruby for humanizing rhythms
require 'csv'
require 'complex'

# DFT and inverse.
#
# Algorithm from
# 'Meyberg, Vachenauer: Hoehere Mathematik II, Springer Berlin, 1991, page 332'
#
# See http://blog.mro.name/2011/04/simple-ruby-fast-fourier-transform/
#
def fft!(src, doinverse = false)
  # raise ArgumentError.new "Expected array input but was '#{src.class}'" unless src.kind_of? Array
  n = src.length
  nlog2 = Math.log( n ) / Math.log( 2 )
  raise ArgumentError.new "Input array size must be a power of two but was '#{n}'" unless nlog2.floor == nlog2
  n2 = n / 2
  phi = Math::PI / n2
  if doinverse
    phi = -phi
  else
    src.collect!{|c| c /= n.to_f}
  end

  # build a sine/cosine table
  wt = Array.new n2
  wt.each_index {|i|
    wt[i] = Complex(Math.cos(i * phi),
                    Math.sin(i * phi))
  }

  # bit reordering
  n1 = n - 1
  j = 0
  1.upto(n1) do |i|
    m = n2
    while j >= m
      j -= m
      m /= 2
    end
    j += m
    src[i],src[j] = src[j],src[i] if j > i
  end

  # 1d(N) Ueberlagerungen
  mm = 1
  begin
    m = mm
    mm *= 2
    0.upto(m - 1) do |k|
      w = wt[ k * n2 ]
      k.step(n1, mm) do |i|
        j = i + m
        src[j] = src[i] - (temp = w * src[j])
        src[i] += temp
      end
    end
    n2 /= 2
  end while mm != n
  src
end

def linspace(initVal, last, num)
  arr = [*initVal..num]
  arr = arr.collect{|i| i.to_f*last/num}
  return arr
end

def stddev(a)
  sum = a.inject(0.0) { |result, el| result + el }
  avg = sum / a.size
  distance = a.inject(0.0){|result, element| result + (element - avg)**2}
  Math.sqrt(distance/a.length)
end

# generate 1/f^alpha noise with N data points.
def noise(alpha=1, n=1000.0, seed=(1e6*rand).floor, verbose=1)
  # n phases and n amplitudes result in 2*n real data points x(t) after FFT.
  nn = (n/2.0).ceil

  # Frequencies in Interval [0, 1/2]
  f = linspace(0, 1/2.0, nn)

  # 1/f^alpha power spectral density
  s = f.map {|val| 1.0/(val ** alpha) }

  # zero mean ???
  s[0] = 0

  # random phases uniformly distributed in [0, 2pi]
  rand_gen = Random.new(seed)
  phi = rand_gen.rand(Range.new(1.0, nn)) * 2.0 * Math::PI
  amp = s.map {|val| Math.sqrt(val) }
  y = amp.map {|val| val * Math.exp(1.0i * phi) }

  # symmetrize Y(N-k+2)) = conj(Y(k)) for k=2...N.
  yy = [y, 0, y[1..-1].map(&:conj).reverse].flatten
  x = fft!(yy, true) # inverse FFT
  x = x[0..nn]  # for odd N we generated N+1 data points.

  # set standard deviation to 1
  x_stddev = stddev(x)
  x = x.map {|val| val/x_stddev }

  if verbose > 0.5
    puts printf('Generated 1/f^alpha noise with alpha=%2.1f\n',alpha)
  end

  return x
end

def humanizer(input_filename, sigma=10, alpha=1, type=2,
                seed=(1e6*rand).floor, verbose=1, sigma2=sigma,
                alpha2=alpha, w=0.5)

  # get notes and times
  # get 'tatum' - smallest possible deviation

  # should be no. of notes
  len_humanize = (2048 - 2)

  case type
  when 0
    # exact
  when 1
    # group humanize
  when 2
    # solo humanize
    x = noise(alpha, len_humanize, seed).map {|val |
      val.real * (sigma/1000.0)
    }
    # because correlations in x and y shall be identical here (but stddev can differ)!
    y = x.map {|val|
      val.real * (sigma2/1000.0)
    }
  else
  end

  # renormalize deviations (except for exact version)
  if type != 0

      # don't modify the first beat!
      x[0] = 0;
      y[0] = 0;

      # reduce rare large changes in the deviations (outside 2*sigma) by factor of 2
      xcounter = 0;
      ycounter = 0;
      x[1..-1].each do |kk|
        if (x[kk] - x[kk-1]).abs > (2.0 * sigma/1000.0)
          x[kk] = (( x[kk] + x[kk-1] ) / 2.0)
          xcounter = xcounter + 1;
        end
      end

      y[1..-1].each do |kk|
        if (y[kk] - y[kk-1]).abs > (2.0 * sigma2/1000.0)
          y[kk] = (( y[kk] + y[kk-1] ) / 2.0)
          ycounter = ycounter + 1;
        end
      end

      # set standard deviation to 1
      x_stddev = stddev(x)
      x = x.map {|val| val/x_stddev * sigma/1000.0 }

      y_stddev = stddev(y)
      y = y.map {|val| val/y_stddev * sigma2/1000.0 }
  end

  x.zip(y)
end

class CSV
  def CSV.unparse array
    CSV.generate do |csv|
      array.each { |i| csv << i }
    end
  end
end

puts CSV.unparse(humanizer('foo'))
