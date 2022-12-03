require "../support"

POINTS1 = {
  "A X" => 4, "B X" => 1, "C X" => 7,
  "A Y" => 8, "B Y" => 5, "C Y" => 2,
  "A Z" => 3, "B Z" => 9, "C Z" => 6,
}

solve do
  test <<-INPUT, 15
    A Y
    B X
    C Z
    INPUT

  answer &.each_line
    .sum { |v| POINTS1[v] }
end

m_solve do
  m_test <<-INPUT, 15
    A Y
    B X
    C Z
    INPUT

  m_answer &.lines
    .map { |v| POINTS1[v] }
    .reduce { |x, y| x + y }
end

POINTS2 = {
  "A X" => 3, "B X" => 1, "C X" => 2,
  "A Y" => 4, "B Y" => 5, "C Y" => 6,
  "A Z" => 8, "B Z" => 9, "C Z" => 7,
}

solve do
  test <<-INPUT, 12
    A Y
    B X
    C Z
    INPUT

  answer &.each_line
    .sum { |v| POINTS2[v] }
end

m_solve do
  m_test <<-INPUT, 12
    A Y
    B X
    C Z
    INPUT

  m_answer &.lines
    .map { |v| POINTS2[v] }
    .reduce { |x, y| x + y }
end
