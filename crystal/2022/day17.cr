require "../support"

PIECES = [
  [Point2D.new(2, 0), Point2D.new(3, 0), Point2D.new(4, 0), Point2D.new(5, 0)],
  [Point2D.new(2, -1), Point2D.new(3, -1), Point2D.new(4, -1), Point2D.new(3, -2), Point2D.new(3, 0)],
  [Point2D.new(2, 0), Point2D.new(3, 0), Point2D.new(4, 0), Point2D.new(4, -1), Point2D.new(4, -2)],
  [Point2D.new(2, 0), Point2D.new(2, -1), Point2D.new(2, -2), Point2D.new(2, -3)],
  [Point2D.new(2, 0), Point2D.new(2, -1), Point2D.new(3, 0), Point2D.new(3, -1)],
]

solve do
  test ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>", 3068

  answer do |input|
    walls = Array.new(7) { |x| Point2D.new(x, 0) }.to_set
    ymin = 0
    dirs = input.chars.cycle.map { |ch| Vector2D.new(ch == '<' ? -1 : 1, 0) }

    PIECES.cycle.first(2022).each do |piece|
      offset = Vector2D.new(0, ymin - 4)
      piece = piece.map &.+(offset)
      while true
        dir = dirs.next.as(Vector2D)
        piece2 = piece.map &.+(dir)
        piece = piece2 if piece2.all? { |v| 0 <= v.x <= 6 && !walls.includes?(v) }

        dir = Vector2D.new(0, 1)
        piece2 = piece.map &.+(dir)
        if piece2.any? { |v| walls.includes?(v) }
          walls.concat(piece)
          ymin = {ymin, piece.min_of(&.y)}.min
          break
        end
        piece = piece2
      end
    end
    -ymin
  end
end

solve do
  test ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>", "1514285714288"

  answer do |input|
    walls = Array.new(7) { |x| Point2D.new(x, 0) }.to_set
    ymin = 0
    dirs = input.chars.cycle.map { |ch| Vector2D.new(ch == '<' ? -1 : 1, 0) }
    loop_count = test_mode? ? 35 : 1755

    pieces = PIECES.cycle
    (1000000000000 % loop_count).times do
      offset = Vector2D.new(0, ymin - 4)
      piece = pieces.next.as(Array(Point2D)).map &.+(offset)
      while true
        dir = dirs.next.as(Vector2D)
        piece2 = piece.map &.+(dir)
        piece = piece2 if piece2.all? { |v| 0 <= v.x <= 6 && !walls.includes?(v) }

        dir = Vector2D.new(0, 1)
        piece2 = piece.map &.+(dir)
        if piece2.any? { |v| walls.includes?(v) }
          walls.concat(piece)
          ymin = {ymin, piece.min_of(&.y)}.min
          break
        end
        piece = piece2
      end
    end

    ymin_old = ymin
    loop_count.times do
      offset = Vector2D.new(0, ymin - 4)
      piece = pieces.next.as(Array(Point2D)).map &.+(offset)
      while true
        dir = dirs.next.as(Vector2D)
        piece2 = piece.map &.+(dir)
        piece = piece2 if piece2.all? { |v| 0 <= v.x <= 6 && !walls.includes?(v) }

        dir = Vector2D.new(0, 1)
        piece2 = piece.map &.+(dir)
        if piece2.any? { |v| walls.includes?(v) }
          walls.concat(piece)
          ymin = {ymin, piece.min_of(&.y)}.min
          break
        end
        piece = piece2
      end
    end
    (1000000000000 // loop_count - 1) * (ymin_old - ymin) - ymin
  end
end
