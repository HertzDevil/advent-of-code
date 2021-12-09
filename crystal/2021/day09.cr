require "../support"
require "bit_array"

solve do
  test <<-INPUT, 15
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    INPUT

  answer do |input|
    field = input.each_line.map(&.chars.map(&.to_i)).to_a
    field.each_with_index.sum do |row, y|
      row.each_with_index.sum do |cell, x|
        cell < (field.dig?(y, x - 1) || 10) &&
          cell < (field.dig?(y, x + 1) || 10) &&
          cell < (field.dig?(y - 1, x) || 10) &&
          cell < (field.dig?(y + 1, x) || 10) ? cell + 1 : 0
      end
    end
  end
end

solve do
  test <<-INPUT, 1134
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    INPUT

  answer do |input|
    field = input.each_line.map(&.chars.map(&.!= '9')).to_a
    found_basin = field.map { |vs| BitArray.new(vs.size, false) }
    basin_sizes = [] of Int32

    field.each_with_index do |row, y|
      row.each_with_index do |is_basin, x|
        next if !is_basin || found_basin[y][x]

        found_basin[y][x] = true
        basin_size = 1
        frontier = [{x, y}]

        until frontier.empty?
          new_frontier = [] of {Int32, Int32}

          frontier.each do |(x1, y1)|
            { {x1 - 1, y1}, {x1 + 1, y1}, {x1, y1 - 1}, {x1, y1 + 1} }.each do |(x2, y2)|
              if x2 >= 0 && y2 >= 0 && field.dig?(y2, x2) && !found_basin[y2][x2]
                new_frontier << {x2, y2}
                found_basin[y2][x2] = true
                basin_size += 1
              end
            end
          end

          frontier = new_frontier
        end

        basin_sizes << basin_size
      end
    end

    basin_sizes.sort!
    basin_sizes.reverse!
    basin_sizes[...3].product
  end
end
