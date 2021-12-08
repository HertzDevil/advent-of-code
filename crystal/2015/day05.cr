require "../support"

solve do
  test "ugknbfddgicrmopn", 1
  test "aaa", 1
  test "jchzalrnumimnmhp", 0
  test "haegwjzuvuyypxyu", 0
  test "dvszwmarrgswjxmb", 0

  answer &.each_line
    .count { |str|
      str.count("aeiou") >= 3 &&
        str.matches?(/(.)\1/) &&
        !str.matches?(/ab|cd|pq|xy/)
    }
end

solve do
  test "qjhvhtzxzqqjkmpb", 1
  test "xxyxx", 1
  test "uurcxstgmygtbstg", 0
  test "ieodomkazucvgmuy", 0

  answer &.each_line
    .count { |str|
      str.matches?(/(..).*?\1/) &&
        str.matches?(/(.).\1/)
    }
end
