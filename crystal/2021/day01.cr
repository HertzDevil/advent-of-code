require "../support"

solve do
  test <<-INPUT, 7
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    INPUT

  answer &.each_line
    .map(&.to_i)
    .cons_pair
    .count { |x, y| x < y }
end

solve do
  test <<-INPUT, 5
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    INPUT

  answer &.each_line
    .map(&.to_i)
    .cons(3).map(&.sum)
    .cons_pair
    .count { |x, y| x < y }
end
