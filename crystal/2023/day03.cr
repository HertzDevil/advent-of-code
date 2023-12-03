require "../support"

solve do
  test <<-INPUT, 4361
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    INPUT

  answer do |input|
    grid = input.lines.map(&.chars)

    symbols = Set({Int32, Int32}).new
    grid.each_with_index do |row, y|
      row.each_with_index do |ch, x|
        if ch != '.' && !ch.in?('0'..'9')
          (-1..1).each { |dy| (-1..1).each { |dx| symbols << {x + dx, y + dy} } }
        end
      end
    end

    sum = 0
    grid.each_with_index do |row, y|
      row.join.scan(/\d+/) do |m|
        if (m.begin...m.end).any? { |x| symbols.includes?({x, y}) }
          sum += m[0].to_i
        end
      end
    end

    sum
  end
end

solve do
  test <<-INPUT, 467835
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    INPUT

  answer do |input|
    grid = input.lines.map(&.chars)

    gears = Hash({Int32, Int32}, Array(Int32)).new
    grid.each_with_index do |row, y|
      row.each_with_index do |ch, x|
        if ch == '*'
          gears[{x, y}] = [] of Int32
        end
      end
    end

    grid.each_with_index do |row, y|
      row.join.scan(/\d+/) do |m|
        ->do
          (m.begin...m.end).each do |x|
            (-1..1).each do |dy|
              (-1..1).each do |dx|
                if g = gears[{x + dx, y + dy}]?
                  g << m[0].to_i
                  return
                end
              end
            end
          end
        end.call
      end
    end

    gears.sum { |_, v| v.size == 2 ? v.product : 0 }
  end
end
