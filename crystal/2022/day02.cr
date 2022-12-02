require "../support"

solve do
  test <<-INPUT, 15
    A Y
    B X
    C Z
    INPUT

  points = {
    "A X" => 4, "B X" => 1, "C X" => 7,
    "A Y" => 8, "B Y" => 5, "C Y" => 2,
    "A Z" => 3, "B Z" => 9, "C Z" => 6,
  }

  answer &.each_line.sum { |v| points[v] }
end

solve do
  test <<-INPUT, 12
    A Y
    B X
    C Z
    INPUT

  points = {
    "A X" => 3, "B X" => 1, "C X" => 2,
    "A Y" => 4, "B Y" => 5, "C Y" => 6,
    "A Z" => 8, "B Z" => 9, "C Z" => 7,
  }

  answer &.each_line.sum { |v| points[v] }
end
