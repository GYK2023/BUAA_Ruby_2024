def decode_ways(code)
  s = code.to_s
  return 0 if s[0]=='0'
  dp = Array.new(s.length+1,0)
  dp[0] = dp[1] = 1
  (2..s.length).each { |i|
    dp[i] += dp[i - 1]
    tmp = s[i - 2].to_i * 10 + s[i - 1].to_i
    if tmp >= 1 && tmp <= 26
      dp[i] += dp[i - 2]
    end
  }
  dp[s.length]
end