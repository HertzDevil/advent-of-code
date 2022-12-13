require "../support"
require "json"

def cmp(left : JSON::Any, right : JSON::Any) : Int
  left = left.as_i64? || left.as_a
  right = right.as_i64? || right.as_a
  case {left, right}
  in {Int64, Int64}
    return left <=> right
  in {Int64, Array}
    left = [JSON::Any.new(left)]
  in {Array, Int64}
    right = [JSON::Any.new(right)]
  in {Array, Array}
  end

  left.zip?(right) do |v1, v2|
    return 1 if v2.nil?
    c = cmp(v1, v2)
    return c unless c == 0
  end
  left.size <=> right.size
end

solve do
  test <<-INPUT, 13
    [1,1,3,1,1]
    [1,1,5,1,1]

    [[1],[2,3,4]]
    [[1],4]

    [9]
    [[8,7,6]]

    [[4,4],4,4]
    [[4,4],4,4,4]

    [7,7,7,7]
    [7,7,7]

    []
    [3]

    [[[]]]
    [[]]

    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]
    INPUT

  answer &.each_line
    .reject(&.empty?)
    .map { |v| JSON.parse(v) }
    .slice(2)
    .with_index(offset: 1)
    .select { |(left, right), _| cmp(left, right) < 0 }
    .sum(&.last)
end

solve do
  test <<-INPUT, 140
    [1,1,3,1,1]
    [1,1,5,1,1]

    [[1],[2,3,4]]
    [[1],4]

    [9]
    [[8,7,6]]

    [[4,4],4,4]
    [[4,4],4,4,4]

    [7,7,7,7]
    [7,7,7]

    []
    [3]

    [[[]]]
    [[]]

    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]
    INPUT

  answer do |input|
    packets = input.lines
      .reject(&.empty?)
      .push("[[2]]", "[[6]]")
      .map { |v| {v, JSON.parse(v)} }
      .sort! { |(_, v1), (_, v2)| cmp(v1, v2) }
      .map(&.first)
    (packets.index!("[[2]]") + 1) * (packets.index!("[[6]]") + 1)
  end
end
