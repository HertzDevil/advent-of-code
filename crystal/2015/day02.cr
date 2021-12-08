require "../support"

solve do
  test "2x3x4", 58
  test "1x1x10", 43

  answer &.each_line
    .sum &.match(/\A(\d+)x(\d+)x(\d+)\z/)
      .not_nil!
      .captures
      .map(&.not_nil!.to_i)
      .try { |(l, w, h)|
        2 * (l * w + w * h + h * l) + l * w * h // {l, w, h}.max
      }
end

solve do
  test "2x3x4", 34
  test "1x1x10", 14

  answer &.each_line
    .sum &.match(/\A(\d+)x(\d+)x(\d+)\z/)
      .not_nil!
      .captures
      .map(&.not_nil!.to_i)
      .try { |(l, w, h)|
        2 * (l + w + h - {l, w, h}.max) + l * w * h
      }
end
