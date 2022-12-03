require "../support"

solve do
  test <<-INPUT, 24000
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    INPUT

  answer &.each_line
    .chunk(reuse: true) { |x| Enumerable::Chunk::Drop if x.empty? }
    .map { |_, vs| vs.sum(&.to_i) }
    .max
end

m_solve do
  m_test <<-INPUT, 24000
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    INPUT

  m_answer do |input|
    input.split("\n\n")
      .map(&.split("\n")
            .reject(&.empty?)
            .map(&.to_i)
            .reduce { |x, y| x + y })
      .reduce { |x, y| x > y ? x : y }
  end
end

solve do
  test <<-INPUT, 45000
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    INPUT

  answer &.each_line
    .chunk(reuse: true) { |x| Enumerable::Chunk::Drop if x.empty? }
    .map { |_, vs| vs.sum(&.to_i) }
    .to_a
    .sort
    .[-3..]
    .sum
end

m_solve do
  m_test <<-INPUT, 45000
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    INPUT

  m_answer do |input|
    input.split("\n\n")
      .map(&.split("\n")
            .reject(&.empty?)
            .map(&.to_i)
            .reduce { |x, y| x + y })
      .sort
      .[](-3..)
      .reduce { |x, y| x + y }
  end
end
