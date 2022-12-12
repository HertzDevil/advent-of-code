require "../support"

def adj(y, x, h, w)
  [
    {y - 1, x + 0},
    {y + 0, x - 1},
    {y + 0, x + 1},
    {y + 1, x + 0},
  ].select { |y2, x2| (0 <= y2 < h) && (0 <= x2 < w) }
end

solve do
  test <<-INPUT, 40
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    INPUT

  answer do |input|
    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch.to_i} } }
      .to_h
    e_v = Point2D.new(grid.each_key.max_of(&.x), grid.each_key.max_of(&.y))

    GridBFS.new(grid, VonNeumann2D)
      .path { |_, _, _, dst, d_old, d| d == d_old + dst }
      .finish(&.has_key?(e_v))
      .run(Point2D.new(0, 0))
  end
end

solve do
  test <<-INPUT, 315
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    INPUT

  answer do |input|
    field = input.each_line.map(&.chars.map(&.to_i)).to_a
    field.map! do |row|
      (0..4).flat_map do |i|
        row.map { |v| (v + i - 1) % 9 + 1 }
      end
    end
    field = (0..4).flat_map do |i|
      field.map do |row|
        row.map { |v| (v + i - 1) % 9 + 1 }
      end
    end
    grid = field.each_with_index
      .flat_map { |row, y| row.each_with_index
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h
    e_v = Point2D.new(grid.each_key.max_of(&.x), grid.each_key.max_of(&.y))

    GridBFS.new(grid, VonNeumann2D)
      .path { |_, _, _, dst, d_old, d| d == d_old + dst }
      .finish(&.has_key?(e_v))
      .run(Point2D.new(0, 0))
  end
end
