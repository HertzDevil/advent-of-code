require "../support"

solve do
  test <<-INPUT, 11
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    INPUT

  answer &.lines
    .map(&.split(" ", remove_empty: true).map(&.to_i))
    .transpose
    .map(&.sort!)
    .transpose
    .sum { |(a, b)| (a - b).abs }
end

solve do
  test <<-INPUT, 31
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    INPUT

  answer do |input|
    a, b = input.lines
      .map(&.split(" ", remove_empty: true).map(&.to_i))
      .transpose
    b = b.tally
    a.sum { |v| v * (b[v]? || 0) }
  end
end
