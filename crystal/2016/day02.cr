require "../support"

KEYPAD1 = {
  {0, 0} => '1',
  {1, 0} => '2',
  {2, 0} => '3',
  {0, 1} => '4',
  {1, 1} => '5',
  {2, 1} => '6',
  {0, 2} => '7',
  {1, 2} => '8',
  {2, 2} => '9',
}

KEYPAD2 = {
  {2, 0} => '1',
  {1, 1} => '2',
  {2, 1} => '3',
  {3, 1} => '4',
  {0, 2} => '5',
  {1, 2} => '6',
  {2, 2} => '7',
  {3, 2} => '8',
  {4, 2} => '9',
  {1, 3} => 'A',
  {2, 3} => 'B',
  {3, 3} => 'C',
  {2, 4} => 'D',
}

solve do
  test <<-INPUT, 1985
    ULL
    RRDDD
    LURDL
    UUUUD
    INPUT

  answer &.each_line
    .accumulate({1, 1}) do |v, line|
      line.each_char.reduce(v) do |(x, y), ch|
        dx, dy = ch == 'U' ? {0, -1} : ch == 'D' ? {0, 1} : ch == 'L' ? {-1, 0} : {1, 0}
        v2 = {x + dx, y + dy}
        KEYPAD1.has_key?(v2) ? v2 : {x, y}
      end
    end
    .skip(1)
    .join { |v| KEYPAD1[v] }
end

solve do
  test <<-INPUT, "5DB3"
    ULL
    RRDDD
    LURDL
    UUUUD
    INPUT

  answer &.each_line
    .accumulate({0, 2}) do |v, line|
      line.each_char.reduce(v) do |(x, y), ch|
        dx, dy = ch == 'U' ? {0, -1} : ch == 'D' ? {0, 1} : ch == 'L' ? {-1, 0} : {1, 0}
        v2 = {x + dx, y + dy}
        KEYPAD2.has_key?(v2) ? v2 : {x, y}
      end
    end
    .skip(1)
    .join { |v| KEYPAD2[v] }
end
