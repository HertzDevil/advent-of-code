require "../support"

solve do
  test <<-INPUT, 13
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    INPUT

  answer do |input|
    grid = input.lines.map(&.chars)
    h = grid.size
    w = grid[0].size
    grid.each_with_index.sum do |row, y|
      row.each_with_index.count do |cell, x|
        v = Point2D.new(x, y)
        cell == '@' && Moore2D.neighbors(v).count { |v2| v2.x.in?(0...w) && v2.y.in?(0...h) && grid[v2.y][v2.x] == '@' } < 4
      end
    end
  end
end

m_solve do
  m_test <<-INPUT, 13
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    INPUT

  m_answer do |input|
    grid = input.lines.map(&.chars)
    h = grid.size
    w = grid[0].size
    count = 0

    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if cell == '@'
          neighbors = 0
          Moore2D::OFFSETS.each do |(dx, dy)|
            x2 = x + dx
            y2 = y + dy
            neighbors += 1 if (0 <= x2 < w) && (0 <= y2 < h) && grid[y2][x2] == '@'
          end
          count += 1 if neighbors < 4
        end
      end
    end

    count
  end
end

solve do
  test <<-INPUT, 43
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    INPUT

  answer do |input|
    grid = Point2D.grid_from_input(input) { |ch| Enumerable::Chunk::Drop.new if ch == '.' }
    count = 0

    while true
      remove = [] of Point2D
      grid.each_key do |v|
        if Moore2D.neighbors(v).count { |v2| grid.has_key?(v2) } < 4
          remove << v
        end
      end
      break if remove.empty?
      count += remove.size
      remove.each do |v|
        grid.delete(v)
      end
    end

    count
  end
end

m_solve do
  m_test <<-INPUT, 43
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    INPUT

  m_answer do |input|
    grid = input.lines.map(&.chars)
    h = grid.size
    w = grid[0].size
    looper = [nil]
    count = 0

    looper.each do # while true
      remove = [] of _
      grid.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          if cell == '@'
            neighbors = 0
            Moore2D::OFFSETS.each do |(dx, dy)|
              x2 = x + dx
              y2 = y + dy
              neighbors += 1 if (0 <= x2 < w) && (0 <= y2 < h) && grid[y2][x2] == '@'
            end
            remove << {x, y} if neighbors < 4
          end
        end
      end

      unless remove.empty?
        count += remove.size
        remove.each do |(x, y)|
          grid[y][x] = '.'
        end
        looper << nil # next
      end
    end

    count
  end
end
