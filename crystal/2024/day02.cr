require "../support"

solve do
  test <<-INPUT, 2
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    INPUT

  answer &.each_line.count do |line|
    diff = line.split(' ').map(&.to_i).each_cons_pair.map { |a, b| a - b }.to_a
    diff.all?(&.abs.in?(1..3)) && diff.map(&.sign).uniq.size == 1
  end
end

solve do
  test <<-INPUT, 0
    INPUT

  answer &.each_line.count do |line|
    nums = line.split(' ').map(&.to_i)
    (0...nums.size).any? do |i|
      v = nums.dup
      v.delete_at(i) unless i == nums.size
      diff = v.each_cons_pair.map { |a, b| a - b }.to_a
      diff.all?(&.abs.in?(1..3)) && diff.map(&.sign).uniq.size == 1
    end
  end
end
