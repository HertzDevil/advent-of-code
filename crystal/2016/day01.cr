require "../support"

solve do
  test "R2, L3", 5
  test "R2, R2, R2", 2
  test "R5, L5, R5, R3", 12

  answer do |input|
    v = Point2D.zero
    dv = Vector2D.new(0, 1)

    input.scan(/([LR])(\d+)/) do |m|
      dv = m[1] == "R" ? dv.cw : dv.ccw
      v += m[2].to_i * dv
    end

    v.x.abs + v.y.abs
  end
end

solve do
  test "R8, R4, R4, R8", 4

  answer &->(input : String) do
    v = Point2D.zero
    dv = Vector2D.new(0, 1)
    visited = Set{v}

    input.scan(/([LR])(\d+)/) do |m|
      dv = m[1] == "R" ? dv.cw : dv.ccw
      m[2].to_i.times do
        v += dv
        return v.x.abs + v.y.abs unless visited.add?(v)
      end
    end
  end
end
