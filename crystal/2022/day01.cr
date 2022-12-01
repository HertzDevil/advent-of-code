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
