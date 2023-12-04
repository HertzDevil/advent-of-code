require "../support"

solve do
  test <<-INPUT, 13
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    INPUT

  answer &.each_line
    .sum do |line|
      _, _, line = line.partition(": ")
      winning, _, nums = line.partition(" | ")
      winning = winning.split(' ', remove_empty: true)
      nums = nums.split(' ', remove_empty: true)
      1 << (winning.count(&.in?(nums)) - 1)
    end
end

solve do
  test <<-INPUT, 30
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    INPUT

  answer do |input|
    input = input.lines
    counts = Array.new(input.size, 1)
    input.each_with_index do |line, i|
      _, _, line = line.partition(": ")
      winning, _, nums = line.partition(" | ")
      winning = winning.split(' ', remove_empty: true)
      nums = nums.split(' ', remove_empty: true)
      winning.count(&.in?(nums)).times do |j|
        counts[i + j + 1] += counts[i]
      end
    end
    counts.sum
  end
end
