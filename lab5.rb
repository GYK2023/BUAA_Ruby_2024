keys = STDIN.gets.chomp.split(' ')
values = STDIN.gets.chomp.split(' ')
mapping = keys.each_with_index.inject(Hash.new(0)) do |hash, (key, index)|
  hash[key] = values[index]
  hash
end
puts mapping
