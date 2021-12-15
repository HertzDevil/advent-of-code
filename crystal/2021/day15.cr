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
    field = input.each_line.map(&.chars.map(&.to_i)).to_a
    h = field.size
    w = field[0].size
    reachable = { {0, 0} => 0 }
    frontier = Set{ {0, 0} }

    (1..).each do |d|
      new_frontier = Set({Int32, Int32}).new
      frontier.each do |y1, x1|
        adj(y1, x1, h, w).each do |y2, x2|
          if !reachable.has_key?({y2, x2}) && d == reachable[{y1, x1}] + field[y2][x2]
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

      break d if reachable.has_key?({h - 1, w - 1})
    end
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

    h = field.size
    w = field[0].size
    reachable = { {0, 0} => 0 }
    frontier = Set{ {0, 0} }

    (1..).each do |d|
      new_frontier = Set({Int32, Int32}).new
      frontier.each do |y1, x1|
        adj(y1, x1, h, w).each do |y2, x2|
          if !reachable.has_key?({y2, x2}) && d == reachable[{y1, x1}] + field[y2][x2]
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

      break d if reachable.has_key?({h - 1, w - 1})
    end
  end
end
