def count_ones(n)
  res = 0
  while n > 0
    if n % 2 != 0
      res += 1
    end
    n /= 2
  end
  res
end
