require "../support"

solve do
  test <<-INPUT, 0
    5 10 25
    INPUT

  answer &.each_line
    .map(&.split.map(&.to_i))
    .count { |(a, b, c)| a + b > c && b + c > a && c + a > b }
end

solve do
  test <<-INPUT, 0
     5
    10
    25
    INPUT

  answer &.each_line
    .map(&.split.map(&.to_i))
    .to_a
    .transpose
    .flatten
    .each_slice(3)
    .count { |(a, b, c)| a + b > c && b + c > a && c + a > b }
end
