require "../support"

CARDS = "23456789TJQKA"

# 5
# 41
# 32
# 311
# 221
# 2111
# 11111

solve do
  test <<-INPUT, 6440
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    INPUT

  answer do |input|
    hands = input.lines.map do |line|
      cards, _, bid = line.partition(' ')
      {cards.chars, bid.to_i}
    end
    hands.sort_by! do |cards, _|
      {cards.tally.values.sort!.reverse!, cards.map { |c| CARDS.index!(c) }}
    end
    hands.each_with_index.sum { |(_, bid), i| bid * (i + 1) }
  end
end

CARDS2 = "J23456789TQKA"

solve do
  test <<-INPUT, 5905
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    INPUT

  answer do |input|
    hands = input.lines.map do |line|
      cards, _, bid = line.partition(' ')
      {cards.chars, bid.to_i}
    end
    hands.sort_by! do |cards, _|
      best = cards.uniq.max_of do |j|
        cards.map { |v| v == 'J' ? j : v }.tally.values.sort!.reverse!
      end
      {best, cards.map { |c| CARDS2.index!(c) }}
    end
    hands.each_with_index.sum { |(_, bid), i| bid * (i + 1) }
  end
end
