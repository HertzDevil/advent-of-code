require "../support"

DIRS = {"U" => {0, -1}, "D" => {0, 1}, "L" => {-1, 0}, "R" => {1, 0}}

solve do
  test <<-INPUT, 13
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
    INPUT

  answer do |input|
    hx, hy = {0, 0}
    tx, ty = hx, hy
    visited = Set{ {tx, ty} }

    input.scan(/([UDLR]) (\d+)/) do |m|
      dx, dy = DIRS[m[1]]
      m[2].to_i.times do
        hx += dx
        hy += dy
        if (tx - hx).abs >= 2 || (ty - hy).abs >= 2
          tx -= (tx - hx).sign
          ty -= (ty - hy).sign
        end
        visited << {tx, ty}
      end
    end

    visited.size
  end
end

solve do
  test <<-INPUT, 1
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
    INPUT

  test <<-INPUT, 36
    R 5
    U 8
    L 8
    D 3
    R 17
    D 10
    L 25
    U 20
    INPUT

  answer do |input|
    ts = Array.new(10) { {0, 0} }
    visited = Set{ {0, 0} }

    input.scan(/([UDLR]) (\d+)/) do |m|
      dx, dy = DIRS[m[1]]
      m[2].to_i.times do
        ts.map_with_index! do |(tx, ty), i|
          if i == 0
            {tx + dx, ty + dy}
          else
            hx, hy = ts[i - 1]
            if (tx - hx).abs >= 2 || (ty - hy).abs >= 2
              tx -= (tx - hx).sign
              ty -= (ty - hy).sign
            end
            {tx, ty}
          end
        end
        visited << ts[-1]
      end
    end

    visited.size
  end
end
