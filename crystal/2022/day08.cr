require "../support"

solve do
  test <<-INPUT, 21
    30373
    25512
    65332
    33549
    35390
    INPUT

  answer do |input|
    grid = input.lines.map(&.chars)
    xmax = grid[0].size - 1
    ymax = grid.size - 1

    grid.each_with_index.sum do |row, y|
      row.each_with_index.count do |cell, x|
        (x + 1).upto(xmax).all? { |x2| row[x2] < cell } ||
          (x - 1).downto(0).all? { |x2| row[x2] < cell } ||
          (y + 1).upto(ymax).all? { |y2| grid[y2][x] < cell } ||
          (y - 1).downto(0).all? { |y2| grid[y2][x] < cell }
      end
    end
  end
end

solve do
  test <<-INPUT, 8
    30373
    25512
    65332
    33549
    35390
    INPUT

  answer do |input|
    grid = input.lines.map(&.chars)
    xmax = grid[0].size - 1
    ymax = grid.size - 1

    grid.each_with_index.max_of do |row, y|
      row.each_with_index.max_of do |cell, x|
        {
          (x + 1).upto(xmax).index { |x2| row[x2] >= cell }.try(&.+ 1) || (xmax - x),
          (x - 1).downto(0).index { |x2| row[x2] >= cell }.try(&.+ 1) || x,
          (y + 1).upto(ymax).index { |y2| grid[y2][x] >= cell }.try(&.+ 1) || (ymax - y),
          (y - 1).downto(0).index { |y2| grid[y2][x] >= cell }.try(&.+ 1) || y,
        }.product
      end
    end
  end
end
