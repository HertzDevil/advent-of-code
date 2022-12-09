require "../support"

{% begin %}
  {% chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".chars %}
  PRIORITIES = {
    {% for i in 1..52 %}
      {{ chars[i - 1] }} => {{ i }},
    {% end %}
  }
{% end %}

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

m_solve do
  m_test <<-INPUT, 157
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    INPUT

  m_answer &.lines
    .map { |v|
      a = v.chars[0...v.size // 2]
      b = v.chars[v.size // 2..v.size]
      index = a.find { |ch| b.includes?(ch) }
      PRIORITIES[index]
    }
    .reduce { |x, y| x + y }
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

m_solve do
  m_test <<-INPUT, 70
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    INPUT

  m_answer do |input|
    groups = [] of NoReturn
    input.lines.each_with_index do |v, i|
      groups << [] of NoReturn if i % 3 == 0
      groups.last << v
    end
    groups.map { |v|
      index = v[0].chars.find { |ch| v[1].chars.includes?(ch) && v[2].chars.includes?(ch) }
      PRIORITIES[index]
    }.reduce { |x, y| x + y }
  end
end
