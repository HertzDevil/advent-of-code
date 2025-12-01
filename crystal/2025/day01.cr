require "../support"

solve do
  test <<-INPUT, 3
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    INPUT

  answer &.each_line
    .map(&.sub('L', '-').lchop('R').to_i)
    .accumulate(50)
    .count(&.divisible_by?(100))
end

m_solve do
  m_test <<-INPUT, 3
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    INPUT

  m_answer do |input|
    dial = 50
    count = 0
    input.lines.each do |line|
      dial += line[1..].to_i * (line.starts_with?('L') ? -1 : 1)
      count += 1 if dial % 100 == 0
    end
    count
  end
end

solve do
  test <<-INPUT, 6
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    INPUT

  answer &.each_line
    .map(&.sub('L', '-').lchop('R').to_i)
    .accumulate(50)
    .cons_pair
    .sum { |(a, b)| b > a ? b // 100 - a // 100 : (a - 1) // 100 - (b - 1) // 100 }
end

m_solve do
  m_test <<-INPUT, 6
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    INPUT

  m_answer do |input|
    dial = 50
    count = 0
    input.lines.each do |line|
      rot = line[1..].to_i * (line.starts_with?('L') ? -1 : 1)
      count += rot > 0 ? (dial + rot) // 100 - dial // 100 : (dial - 1) // 100 - (dial + rot - 1) // 100
      dial += rot
    end
    count
  end
end
