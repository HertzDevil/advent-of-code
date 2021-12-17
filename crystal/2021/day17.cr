require "../support"

solve do
  test "target area: x=20..30, y=-10..-5", 45

  answer do |input|
    x1, x2, y1, y2 = input.match(/target area: x=(-?[0-9]+)..(-?[0-9]+), y=(-?[0-9]+)..(-?[0-9]+)/).not_nil!.captures.map(&.not_nil!.to_i)
    n = {-y1, -y2}.max
    n * (n - 1) // 2
  end
end

def lands?(dx, dy, x1, x2, y1, y2)
  x = 0
  y = 0

  while true
    x += dx
    y += dy
    return true if (x1 <= x <= x2) && (y1 <= y <= y2)
    return false if y < y1

    if dx > 0
      dx -= 1
    elsif dx < 0
      dx += 1
    end
    dy -= 1
  end
end

solve do
  test "target area: x=20..30, y=-10..-5", 112

  answer do |input|
    x1, x2, y1, y2 = input.match(/target area: x=(-?[0-9]+)..(-?[0-9]+), y=(-?[0-9]+)..(-?[0-9]+)/).not_nil!.captures.map(&.not_nil!.to_i)
    x1, x2 = {x1, x2}.minmax
    y1, y2 = {y1, y2}.minmax

    dx0_min, dx0_max = {0, x1, x2}.minmax
    dy0_min = {0, y1, y2}.min
    dy0_max = {0, y1.abs, y2.abs}.max

    (dx0_min..dx0_max).sum do |dx0|
      (dy0_min..dy0_max).count do |dy0|
        lands?(dx0, dy0, x1, x2, y1, y2)
      end
    end
  end
end
