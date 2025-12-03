require "../support"

def max_joltage(batteries, n)
  digits = [] of Int64

  start_pos = 0
  n.times do |i|
    range = batteries[start_pos..-n + i]
    digit = range.max
    digits << digit
    start_pos += range.index!(digit) + 1
  end

  Int64.from_digits(digits.reverse!)
end

MaxJoltage = ->(batteries, n) do
  digits = [] of _

  start_pos = 0
  (0...n).each do |i|
    range = batteries[start_pos..-n + i]
    digit = M::Array::Max.call(range)
    digits << digit
    start_pos += M::Array::Index.call(range, digit) + 1
  end

  M::Math::FromDigits.call(M::Array::ReverseB.call(digits), 10)
end

solve do
  test <<-INPUT, 357
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    INPUT

  answer &.each_line
    .sum { |line| max_joltage(line.chars.map(&.to_i64), 2) }

  # answer &.each_line
  #   .sum &.chars
  #     .map(&.to_i64)
  #     .each_combination(2)
  #     .map(&.reverse!)
  #     .max_of(&->Int64.from_digits(Array(Int64)))
end

m_solve do
  m_test <<-INPUT, 357_i64
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    INPUT

  m_answer do |input|
    M::Array::Sum.call(input.lines.map(&.chars.map(&.id.to_i)), MaxJoltage, 2)
  end
end

solve do
  test <<-INPUT, 3121910778619
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    INPUT

  answer &.each_line
    .sum { |line| max_joltage(line.chars.map(&.to_i64), 12) }
end

m_solve do
  m_test <<-INPUT, 3121910778619_i64
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    INPUT

  m_answer do |input|
    M::Array::Sum.call(input.lines.map(&.chars.map(&.id.to_i)), MaxJoltage, 12)
  end
end
