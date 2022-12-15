require "../support"

KEYPAD1 = {
  Point2D.new(0, 0) => '1',
  Point2D.new(1, 0) => '2',
  Point2D.new(2, 0) => '3',
  Point2D.new(0, 1) => '4',
  Point2D.new(1, 1) => '5',
  Point2D.new(2, 1) => '6',
  Point2D.new(0, 2) => '7',
  Point2D.new(1, 2) => '8',
  Point2D.new(2, 2) => '9',
}

KEYPAD2 = {
  Point2D.new(2, 0) => '1',
  Point2D.new(1, 1) => '2',
  Point2D.new(2, 1) => '3',
  Point2D.new(3, 1) => '4',
  Point2D.new(0, 2) => '5',
  Point2D.new(1, 2) => '6',
  Point2D.new(2, 2) => '7',
  Point2D.new(3, 2) => '8',
  Point2D.new(4, 2) => '9',
  Point2D.new(1, 3) => 'A',
  Point2D.new(2, 3) => 'B',
  Point2D.new(3, 3) => 'C',
  Point2D.new(2, 4) => 'D',
}

solve do
  test <<-INPUT, 1985
    ULL
    RRDDD
    LURDL
    UUUUD
    INPUT

  answer &.each_line
    .accumulate(Point2D.new(1, 1)) do |v, line|
      line.each_char.reduce(v) do |v, ch|
        v2 = v + Vector2D::FROM_CHAR[ch]
        KEYPAD1.has_key?(v2) ? v2 : v
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
    .accumulate(Point2D.new(0, 2)) do |v, line|
      line.each_char.reduce(v) do |v, ch|
        v2 = v + Vector2D::FROM_CHAR[ch]
        KEYPAD2.has_key?(v2) ? v2 : v
      end
    end
    .skip(1)
    .join { |v| KEYPAD2[v] }
end
