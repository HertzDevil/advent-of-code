require "../support"

solve do
  test <<-INPUT, 114
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    INPUT

  answer &.each_line
    .sum do |line|
      values = [line.split(' ').map(&.to_i)]
      until values.last.all?(&.zero?)
        values << values.last.each_cons_pair.map { |a, b| b - a }.to_a
      end
      values.sum(&.last)
    end
end

solve do
  test <<-INPUT, 2
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    INPUT

  answer &.each_line
    .sum do |line|
      values = [line.split(' ').map(&.to_i)]
      until values.last.all?(&.zero?)
        values << values.last.each_cons_pair.map { |a, b| b - a }.to_a
      end
      values.each_with_index.sum { |row, i| row.first * (i.odd? ? -1 : 1) }
    end
end
