require "../support"

OFFSET = {'^' => {0, -1}, '>' => {1, 0}, 'v' => {0, 1}, '<' => {-1, 0}}

solve do
  test ">", 2
  test "^>v<", 4
  test "^v^v^v^v^v", 2

  answer &.each_char
    .map { |dir| OFFSET[dir] }
    .accumulate({0, 0}) { |(x, y), (dx, dy)| {x + dx, y + dy} }
    .uniq
    .size
end

solve do
  test "^v", 3
  test "^>v<", 3
  test "^v^v^v^v^v", 11

  answer &.each_char
    .map { |dir| OFFSET[dir] }
    .zip((0..1).cycle)
    .accumulate({0, 0, 0, 0}) { |(x1, y1, x2, y2), (d, i)|
      {
        x1 + d[0] * (1 - i), y1 + d[1] * (1 - i),
        x2 + d[0] * i, y2 + d[1] * i,
      }
    }
    .flat_map(&.each_slice(2))
    .uniq
    .size
end
