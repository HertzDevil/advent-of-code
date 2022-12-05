require "../support"

solve do
  test <<-INPUT, 2
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    INPUT

  answer &.scan(/\d+/)
    .map(&.[0].to_i)
    .each_slice(4)
    .count { |(a, b, c, d)| (a >= c && b <= d) || (c >= a && d <= b) }
end

solve do
  test <<-INPUT, 4
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    INPUT

  answer &.scan(/\d+/)
    .map(&.[0].to_i)
    .each_slice(4)
    .count { |(a, b, c, d)| b >= c && a <= d }
end
