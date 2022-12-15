require "../support"

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
    h = Point2D.zero
    t = h
    visited = Set{t}

    input.scan(/([UDLR]) (\d+)/) do |m|
      dh = Vector2D::FROM_STR[m[1]]
      m[2].to_i.times do
        h += dh
        if (t.x - h.x).abs >= 2 || (t.y - h.y).abs >= 2
          t -= Vector2D.new(t.x <=> h.x, t.y <=> h.y)
        end
        visited << t
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
    ts = Array.new(10) { Point2D.zero }
    visited = Set{Point2D.zero}

    input.scan(/([UDLR]) (\d+)/) do |m|
      dt = Vector2D::FROM_STR[m[1]]
      m[2].to_i.times do
        ts.map_with_index! do |t, i|
          if i == 0
            t + dt
          else
            h = ts[i - 1]
            if (t.x - h.x).abs >= 2 || (t.y - h.y).abs >= 2
              t -= Vector2D.new(t.x <=> h.x, t.y <=> h.y)
            end
            t
          end
        end
        visited << ts[-1]
      end
    end

    visited.size
  end
end
