require "../support"

def adj(y, x, h, w)
  [
    {y - 1, x - 1},
    {y - 1, x + 0},
    {y - 1, x + 1},
    {y + 0, x - 1},
    {y + 0, x + 1},
    {y + 1, x - 1},
    {y + 1, x + 0},
    {y + 1, x + 1},
  ].select { |y2, x2| (0 <= y2 < h) && (0 <= x2 < w) }
end

solve do
  test <<-INPUT, 1656
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    INPUT

  answer do |input|
    grid = input.each_line.map(&.chars.map(&.to_i)).to_a
    flash_count = 0

    100.times do |t|
      all_flashed = Set({Int32, Int32}).new
      flashed = Set({Int32, Int32}).new
      grid.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          row[x] = cell + 1
          flashed << {y, x} if cell >= 9
          all_flashed << {y, x} if cell >= 9
        end
      end

      while true
        new_flashed = Set({Int32, Int32}).new
        flashed.each do |(y1, x1)|
          adj(y1, x1, 10, 10).each do |(y2, x2)|
            grid[y2][x2] += 1
            if grid[y2][x2] > 9 && !all_flashed.includes?({y2, x2})
              new_flashed << {y2, x2}
              all_flashed << {y2, x2}
            end
          end
        end
        break if new_flashed.empty?
        all_flashed.concat(flashed)
        flashed = new_flashed
      end

      flash_count += all_flashed.size
      all_flashed.each do |(y, x)|
        grid[y][x] = 0
      end
    end

    flash_count
  end
end

solve do
  test <<-INPUT, 195
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    INPUT

  answer do |input|
    grid = input.each_line.map(&.chars.map(&.to_i)).to_a

    (1..).each do |t|
      flash_count = 0

      all_flashed = Set({Int32, Int32}).new
      flashed = Set({Int32, Int32}).new
      grid.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          row[x] = cell + 1
          flashed << {y, x} if cell >= 9
          all_flashed << {y, x} if cell >= 9
        end
      end

      while true
        new_flashed = Set({Int32, Int32}).new
        flashed.each do |(y1, x1)|
          adj(y1, x1, 10, 10).each do |(y2, x2)|
            grid[y2][x2] += 1
            if grid[y2][x2] > 9 && !all_flashed.includes?({y2, x2})
              new_flashed << {y2, x2}
              all_flashed << {y2, x2}
            end
          end
        end
        break if new_flashed.empty?
        all_flashed.concat(flashed)
        flashed = new_flashed
      end

      flash_count += all_flashed.size
      all_flashed.each do |(y, x)|
        grid[y][x] = 0
      end

      break t if flash_count == 100
    end
  end
end
