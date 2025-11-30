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

Transpose = ->(arr : ArrayLiteral) : ArrayLiteral {
  if arr.empty?
    [] of ::NoReturn
  else
    height = arr.size
    width = nil
    arr.each do |v|
      width ||= v.size
      arr.raise "jagged array" unless v.size == width
    end

    (0...width).map do |x|
      (0...height).map do |y|
        arr[y][x]
      end
    end
  end
}

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
    v = Transpose.call(input.lines.map(&.split(/\s+/).map(&.to_i)))
    v = Transpose.call(v.map(&.sort))
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

Itself = ->(x) { x }

TallyBy = ->(arr : ArrayLiteral, block : ProcLiteral) : HashLiteral {
  tallies = {} of _ => _
  arr.each do |k|
    value = block.call(k)
    tallies[value] = (tallies[value] || 0) + 1
  end
  tallies
}

Tally = ->(arr : ArrayLiteral) : HashLiteral {
  TallyBy.call(arr, Itself)
}

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
    a, b = Transpose.call(input.lines.map(&.split(/\s+/).map(&.to_i)))
    b = Tally.call(b)
    a.reduce(0) { |sum, v| sum + v * (b[v] || 0) }
  end
end
