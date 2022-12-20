require "../support"

solve do
  test <<-INPUT, 3
    1
    2
    -3
    3
    -2
    0
    4
    INPUT

  answer do |input|
    values = input.lines.map_with_index { |x, i| {x.to_i, i} }
    values.size.times do |i|
      j = values.index! { |_, i2| i == i2 }
      v = values.delete_at(j)
      values.insert((v[0] + j) % values.size, v)
    end
    i0 = values.index! { |x, _| x == 0 }
    {1000, 2000, 3000}.sum { |j| values[(i0 + j) % values.size][0] }
  end
end

solve do
  test <<-INPUT, 1623178306
    1
    2
    -3
    3
    -2
    0
    4
    INPUT

  answer do |input|
    values = input.lines.map_with_index { |x, i| {811589153_i64 * x.to_i, i} }
    10.times do
      values.size.times do |i|
        j = values.index! { |_, i2| i == i2 }
        v = values.delete_at(j)
        values.insert((v[0] + j) % values.size, v)
      end
    end
    i0 = values.index! { |x, _| x == 0 }
    {1000, 2000, 3000}.sum { |j| values[(i0 + j) % values.size][0] }
  end
end
