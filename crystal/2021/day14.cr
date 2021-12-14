require "../support"

solve do
  test <<-INPUT, 1588
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    INPUT

  answer do |input|
    polymer = ""
    rules = {} of {Char, Char} => Char

    input.each_line do |line|
      case line
      when /\A([A-Z])([A-Z]) -> ([A-Z])\z/
        rules[{$1[0], $2[0]}] = $3[0]
      when /.+/
        polymer = line
      end
    end

    10.times do
      polymer = String.build do |io|
        io << polymer[0]
        polymer.each_char.cons_pair.each do |x, y|
          grow = rules[{x, y}]
          io << grow if grow
          io << y
        end
      end
    end

    lowest, highest = polymer.chars.tally.values.minmax
    highest - lowest
  end
end

solve do
  test <<-INPUT, 2188189693529
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    INPUT

  answer do |input|
    polymer = ""
    rules = {} of {Char, Char} => Char

    input.each_line do |line|
      case line
      when /\A([A-Z])([A-Z]) -> ([A-Z])\z/
        rules[{$1[0], $2[0]}] = $3[0]
      when /.+/
        polymer = line
      end
    end

    first_char = polymer[0]
    last_char = polymer[-1]
    polymer = polymer.each_char.cons_pair.tally.transform_values &.to_i64

    40.times do
      new_polymer = {} of {Char, Char} => Int64
      polymer.each do |(x, y), count|
        if grow = rules[{x, y}]?
          new_polymer[{x, grow}] ||= 0_i64
          new_polymer[{x, grow}] += count
          new_polymer[{grow, y}] ||= 0_i64
          new_polymer[{grow, y}] += count
        else
          new_polymer[{x, y}] ||= 0_i64
          new_polymer[{x, y}] += count
        end
      end
      polymer = new_polymer
    end

    counts = {first_char => 1_i64, last_char => 1_i64}
    polymer.each do |(x, y), count|
      counts[x] ||= 0_i64
      counts[x] += count
      counts[y] ||= 0_i64
      counts[y] += count
    end
    lowest, highest = counts.values.minmax
    (highest - lowest) // 2
  end
end
