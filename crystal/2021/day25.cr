require "../support"

solve do
  test <<-INPUT, 58
    v...>>.vv>
    .vv>>.vv..
    >>.>v>...v
    >>v>>.>.v.
    v>v.vv.v..
    >.>>..v...
    .vv..>.>v.
    v.v..>>v.v
    ....v..v.>
    INPUT

  answer do |input|
    map = input.each_line.map(&.chars).to_a
    h = map.size
    w = map[0].size

    (1..).each do |t|
      hmoves = [] of {Int32, Int32}
      map.each_with_index do |row, y|
        row.each_with_index do |ch, x|
          hmoves << {y, x} if ch == '>' && row[(x + 1) % w] == '.'
        end
      end
      hmoves.each do |(y, x)|
        map[y][x] = '.'
        map[y][(x + 1) % w] = '>'
      end

      vmoves = [] of {Int32, Int32}
      map.each_with_index do |row, y|
        row.each_with_index do |ch, x|
          vmoves << {y, x} if ch == 'v' && map[(y + 1) % h][x] == '.'
        end
      end
      vmoves.each do |(y, x)|
        map[y][x] = '.'
        map[(y + 1) % h][x] = 'v'
      end

      break t if hmoves.empty? && vmoves.empty?
    end
  end
end
