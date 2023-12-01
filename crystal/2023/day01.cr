require "../support"

solve do
  test <<-INPUT, 142
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    INPUT

  answer &.each_line
    .sum { |str|
      digits = str.scan(/\d/)
      digits[0][0].to_i * 10 + digits[-1][0].to_i
    }
end

DIGITS = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
  "1" => 1,
  "2" => 2,
  "3" => 3,
  "4" => 4,
  "5" => 5,
  "6" => 6,
  "7" => 7,
  "8" => 8,
  "9" => 9,
}

solve do
  test <<-INPUT, 281
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    INPUT

  answer &.each_line
    .sum { |str|
      digit1 = str.match!(/(#{DIGITS.keys.join('|')})/)[1]
      digit2 = str.match!(/.*(#{DIGITS.keys.join('|')})/)[1]
      DIGITS[digit1] * 10 + DIGITS[digit2]
    }
end
