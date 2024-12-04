require "../support"

moore = [
  Vector2D.new(-1, -1),
  Vector2D.new(+0, -1),
  Vector2D.new(+1, -1),
  Vector2D.new(-1, +0),
  Vector2D.new(+1, +0),
  Vector2D.new(-1, +1),
  Vector2D.new(+0, +1),
  Vector2D.new(+1, +1),
]

solve do
  test <<-INPUT, 18
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    INPUT

  answer do |input|
    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h

    grid.sum do |v0, ch|
      next 0 unless ch == 'X'
      moore.count do |d|
        grid[v0 + d]? == 'M' && grid[v0 + d * 2]? == 'A' && grid[v0 + d * 3]? == 'S'
      end
    end
  end
end

solve do
  test <<-INPUT, 9
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    INPUT

  answer do |input|
    grid = input.each_line
      .with_index
      .flat_map { |row, y| row.each_char
        .with_index
        .map { |ch, x| {Point2D.new(x, y), ch} } }
      .to_h

    grid.count do |v0, ch|
      next unless ch == 'A'
      a = grid[v0 + Vector2D.new(-1, -1)]? || next
      b = grid[v0 + Vector2D.new(-1, +1)]? || next
      c = grid[v0 + Vector2D.new(+1, -1)]? || next
      d = grid[v0 + Vector2D.new(+1, +1)]? || next
      {a, d}.minmax == {'M', 'S'} && {b, c}.minmax == {'M', 'S'}
    end
  end
end
