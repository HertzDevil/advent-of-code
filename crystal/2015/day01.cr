require "../support"

solve do
  test "(())", 0
  test "()()", 0
  test "(((", 3
  test "(()(()(", 3
  test "))(((((", 3
  test "())", -1
  test "))(", -1
  test ")))", -3
  test ")())())", -3

  answer &.each_char
    .sum { |ch| ch == '(' ? 1 : ch == ')' ? -1 : 0 }
end

solve do
  test ")", 1
  test "()())", 5

  answer &.each_char
    .accumulate(0) { |acc, ch| acc + (ch == '(' ? 1 : ch == ')' ? -1 : 0) }
    .index { |x| x < 0 }.not_nil!
end
