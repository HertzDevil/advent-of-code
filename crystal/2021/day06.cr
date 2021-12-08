require "../support"

solve do
  test "3,4,3,1,2", 5934

  answer do |input|
    states = input.split(",").map(&.to_i).tally
    (0..8).each { |i| states[i] ||= 0 }
    80.times do
      produce = states[0]
      states = {
        0 => states[1],
        1 => states[2],
        2 => states[3],
        3 => states[4],
        4 => states[5],
        5 => states[6],
        6 => states[7] + states[0],
        7 => states[8],
        8 => states[0],
      }
    end
    states.values.sum
  end
end

solve do
  test "3,4,3,1,2", 26984457539_i64

  answer do |input|
    states = input.split(",").map(&.to_i).tally.transform_values(&.to_i64)
    (0..8).each { |i| states[i] ||= 0_i64 }
    256.times do
      produce = states[0]
      states = {
        0 => states[1],
        1 => states[2],
        2 => states[3],
        3 => states[4],
        4 => states[5],
        5 => states[6],
        6 => states[7] + states[0],
        7 => states[8],
        8 => states[0],
      }
    end
    states.values.sum
  end
end
