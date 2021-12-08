require "../support"

solve do
  test "16,1,2,0,4,2,7,1,2,14", 37

  answer do |input|
    pos = input.split(',').map(&.to_i)
    (pos.min..pos.max).map { |pos0| pos.sum(&.-(pos0).abs) }.min
  end
end

solve do
  test "16,1,2,0,4,2,7,1,2,14", 168

  answer do |input|
    pos = input.split(',').map(&.to_i)
    (pos.min..pos.max).map { |pos0| pos.sum { |pos| d = (pos - pos0).abs; d * (d + 1) // 2 } }.min
  end
end
