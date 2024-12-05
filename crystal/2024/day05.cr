require "../support"

solve do
  test <<-INPUT, 143
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    INPUT

  answer do |input|
    orderings, _, updates = input.partition("\n\n")

    orderings = orderings.lines.map do |line|
      a, _, b = line.partition('|')
      {a.to_i, b.to_i}
    end.to_set

    updates.each_line.sum do |line|
      pages = line.split(',').map(&.to_i)
      pages.each_combination(2).none? { |(a, b)| orderings.includes?({b, a}) } ? pages[pages.size // 2] : 0
    end
  end
end

solve do
  test <<-INPUT, 123
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    INPUT

  answer do |input|
    orderings, _, updates = input.partition("\n\n")

    orderings = orderings.lines.map do |line|
      a, _, b = line.partition('|')
      {a.to_i, b.to_i}
    end.to_set

    updates.each_line.sum do |line|
      pages = line.split(',').map(&.to_i)
      pages2 = pages.sort { |a, b| orderings.includes?({a, b}) ? -1 : orderings.includes?({a, b}) ? 1 : 0 } # tsort?
      pages2 == pages ? 0 : pages2[pages2.size // 2]
    end
  end
end
