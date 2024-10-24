# case equality 操作符语义分析
> Case Equality – For class Object, effectively the same as calling #==, but typically overridden by descendants to provide meaningful semantics in case expressions.

case equality(===)通常被Object的子类重写在case表达式中提供有意义的语义。
===操作符的行为取决于左操作数的类型，以下将根据此标准，选取若干典型进行讨论。

### 基本对象的行为
对于数字、字符串等基本对象，===的行为与==相同
```ruby
1.0 === 1 # true
"abcd" === "abcd" # true
```

### 类的行为
对于类，a===b用于检查b是否是a（类）的实例或子类
```ruby
Integer === 5 # true
String === "abcd" # true
Array === [1,2,3] # true

class A; end
class B < A; end
A === B.new # true
```

### 正则表达式的行为
对于正则表达式，使用a===b执行模式匹配，检查b（字符串）是否匹配a（正则表达式）
```ruby
/asdf/ === "asdf" # true
```

### 范围的行为
对于范围，a===b检查b是否在a（范围）内，既可以用于数字范围，也可用于其他可比较的对象
```ruby
(1..2) === 2 # true
(1...2) === 2 # false
('a'..'z') === 'm' # true
```

### 过程的行为
对于Proc对象，===调用该proc并返回结果
```ruby
is_even = proc {|n| n%2 == 0}
is_even === 4 # true
is_even === 5 # false
```