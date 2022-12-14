require "../support"

solve do
  test <<-INPUT, 24
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
    INPUT

  answer do |input|
    rocks = Set({Int32, Int32}).new
    ymax = Int32::MIN
    input.each_line do |line|
      line.scan(/(\d+),(\d+)/).map { |m| {m[1].to_i, m[2].to_i} }.each_cons_pair do |(x1, y1), (x2, y2)|
        x1, x2 = {x1, x2}.minmax
        y1, y2 = {y1, y2}.minmax
        (x1..x2).each do |x|
          (y1..y2).each do |y|
            rocks << {x, y}
          end
        end
        ymax = {ymax, y2}.max
      end
    end

    (0..).each do |n|
      x, y = 500, 0
      blocked = while y <= ymax
        x, y = { {x, y + 1}, {x - 1, y + 1}, {x + 1, y + 1} }.find { |v| !rocks.includes?(v) } || break true
      end
      break n unless blocked
      rocks << {x, y}
    end
  end
end

solve do
  test <<-INPUT, 93
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
    INPUT

  answer do |input|
    rocks = Set({Int32, Int32}).new
    ymax = Int32::MIN
    xmin = Int32::MAX
    xmax = Int32::MIN
    input.each_line do |line|
      line.scan(/(\d+),(\d+)/).map { |m| {m[1].to_i, m[2].to_i} }.each_cons_pair do |(x1, y1), (x2, y2)|
        x1, x2 = {x1, x2}.minmax
        y1, y2 = {y1, y2}.minmax
        (x1..x2).each do |x|
          (y1..y2).each do |y|
            rocks << {x, y}
          end
        end
        xmin = {xmin, x1}.min
        xmax = {xmax, x2}.max
        ymax = {ymax, y2}.max
      end
    end

    (xmin - ymax..xmax + ymax).each do |x|
      rocks << {x, ymax + 2}
    end

    (0..).each do |n|
      x, y = 500, 0
      while true
        x, y = { {x, y + 1}, {x - 1, y + 1}, {x + 1, y + 1} }.find { |v| !rocks.includes?(v) } || break
      end
      break n unless rocks.add?({x, y})
    end
  end
end
