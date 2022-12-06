require "../support"

solve do
  test "mjqjpqmgbljsphdztnvjfqwrcgsmlb", 7
  test "bvwbjplbgvbhsrlpgdmjqwftvncz", 5
  test "nppdvjthqldpwncqszvftbrmjlhg", 6
  test "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 10
  test "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 11

  answer &.each_char
    .cons(4)
    .take_while(&.uniq.size.< 4)
    .count { true }
    .+(4)
end

solve do
  test "mjqjpqmgbljsphdztnvjfqwrcgsmlb", 19
  test "bvwbjplbgvbhsrlpgdmjqwftvncz", 23
  test "nppdvjthqldpwncqszvftbrmjlhg", 23
  test "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 29
  test "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 26

  answer &.each_char
    .cons(14)
    .take_while(&.uniq.size.< 14)
    .count { true }
    .+(14)
end
