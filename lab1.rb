require 'prime'
def mfp(m)
  sum = (1..m).map {|x| x.to_s.chars.map(&:to_i).reject {|d| d == 0}.inject(1, :*)}.sum
  # 求sum的最大质因数
  res = sum.prime_division.map(&:first).max
  if !res.nil?
    res
  else
    1
  end
end

