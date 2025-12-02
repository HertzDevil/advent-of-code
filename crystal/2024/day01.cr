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

m_solve do
  m_test <<-INPUT, 11
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    INPUT

  m_answer do |input|
    v = M::Array::Transpose.call(input.lines.map(&.split(/\s+/).map(&.to_i)))
    v = M::Array::Transpose.call(v.map(&.sort))
    v.reduce(0) { |sum, (a, b)| sum + (a > b ? a - b : b - a) }
  end
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

m_solve do
  m_test <<-INPUT, 31
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    INPUT

  m_answer do |input|
    a, b = M::Array::Transpose.call(input.lines.map(&.split(/\s+/).map(&.to_i)))
    b = M::Array::Tally.call(b)
    a.reduce(0) { |sum, v| sum + v * (b[v] || 0) }
  end
end
