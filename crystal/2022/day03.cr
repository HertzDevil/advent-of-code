require "../support"

solve do
  test <<-INPUT, 157
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    INPUT

  answer &.each_line
    .flat_map { |v| v[...v.size // 2].chars & v[v.size // 2..].chars }
    .sum { |v| v >= 'a' ? v - 'a' + 1 : v - 'A' + 27 }
end

solve do
  test <<-INPUT, 70
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    INPUT

  answer &.each_line
    .slice(3)
    .flat_map { |(x, y, z)| x.chars & y.chars & z.chars }
    .sum { |v| v >= 'a' ? v - 'a' + 1 : v - 'A' + 27 }
end
