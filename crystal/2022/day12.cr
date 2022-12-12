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
  test <<-INPUT, 31
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    INPUT

  answer do |input|
    grid = input.lines.map(&.chars)
    h = grid.size
    w = grid[0].size

    s_y = grid.index! &.includes?('S')
    s_x = grid[s_y].index!('S')
    grid[s_y][s_x] = 'a'

    e_y = grid.index! &.includes?('E')
    e_x = grid[e_y].index!('E')
    grid[e_y][e_x] = 'z'

    reachable = { {s_y, s_x} => 0 }
    frontier = Set{ {s_y, s_x} }

    (1..).each do |d|
      new_frontier = Set({Int32, Int32}).new
      frontier.each do |y1, x1|
        src = grid[y1][x1]
        adj(y1, x1, h, w).each do |y2, x2|
          dest = grid[y2][x2]
          if !reachable.has_key?({y2, x2}) && dest - src <= 1
            reachable[{y2, x2}] = d
            new_frontier << {y2, x2}
          end
        end
      end
      new_frontier.concat(frontier)
      frontier = new_frontier.select do |y1, x1|
        adj(y1, x1, h, w).any? do |y2, x2|
          !reachable.has_key?({y2, x2})
        end
      end

      break d if reachable.has_key?({e_y, e_x})
    end
  end
end

solve do
  test <<-INPUT, 29
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    INPUT

  answer do |input|
    grid = input.lines.map(&.chars)
    h = grid.size
    w = grid[0].size

    s_y = grid.index! &.includes?('S')
    s_x = grid[s_y].index!('S')
    grid[s_y][s_x] = 'a'

    e_y = grid.index! &.includes?('E')
    e_x = grid[e_y].index!('E')
    grid[e_y][e_x] = 'z'

    reachable = { {e_y, e_x} => 0 }
    frontier = Set{ {e_y, e_x} }

    (1..).each do |d|
      new_frontier = Set({Int32, Int32}).new
      frontier.each do |y1, x1|
        src = grid[y1][x1]
        adj(y1, x1, h, w).each do |y2, x2|
          dest = grid[y2][x2]
          if !reachable.has_key?({y2, x2}) && dest - src >= -1
            reachable[{y2, x2}] = d
            new_frontier << {y2, x2}
          end
        end
      end
      new_frontier.concat(frontier)
      frontier = new_frontier.select do |y1, x1|
        adj(y1, x1, h, w).any? do |y2, x2|
          !reachable.has_key?({y2, x2})
        end
      end

      break d if reachable.any? { |(y3, x3), _| grid[y3][x3] == 'a' }
    end
  end
end
