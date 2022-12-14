require "../support"
require "complex"

solve do
  test "R2, L3", 5
  test "R2, R2, R2", 2
  test "R5, L5, R5, R3", 12

  answer do |input|
    z = Complex.zero
    dir = 1.i

    input.scan(/([LR])(\d+)/) do |m|
      dir *= m[1] == "R" ? -1.i : 1.i
      z += m[2].to_i * dir
    end

    (z.real.abs + z.imag.abs).to_i
  end
end

solve do
  test "R8, R4, R4, R8", 4

  answer &->(input : String) do
    x, y = 0, 0
    dx, dy = 0, 1
    visited = Set{ {0, 0} }

    input.scan(/([LR])(\d+)/) do |m|
      dx, dy = m[1] == "R" ? {dy, -dx} : {-dy, dx}
      m[2].to_i.times do
        x, y = x + dx, y + dy
        return x.abs + y.abs unless visited.add?({x, y})
      end
    end
  end
end
