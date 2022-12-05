require "../support"

solve do
  test <<-INPUT, "CMZ"
        [D]\x20\x20\x20\x20
    [N] [C]\x20\x20\x20\x20
    [Z] [M] [P]
    1   2   3

    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
    INPUT

  answer do |input|
    stacks, _, instrs = input.partition(/\n[\d ]*\n\n/)

    stacks = stacks.lines
      .map(&.chars)
      .transpose
      .each_with_index
      .select { |_, i| i % 4 == 1 }
      .map(&.first.skip_while(&.== ' ').reverse!)
      .to_a

    instrs.each_line do |line|
      count, from, to = line.scan(/\d+/).map(&.[0].to_i)
      count.times { stacks[to - 1] << stacks[from - 1].pop }
    end

    stacks.join(&.last)
  end
end

solve do
  test <<-INPUT, "MCD"
        [D]\x20\x20\x20\x20
    [N] [C]\x20\x20\x20\x20
    [Z] [M] [P]
    1   2   3

    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
    INPUT

  answer do |input|
    stacks, _, instrs = input.partition(/\n[\d ]*\n\n/)

    stacks = stacks.lines
      .map(&.chars)
      .transpose
      .each_with_index
      .select { |_, i| i % 4 == 1 }
      .map(&.first.skip_while(&.== ' ').reverse!)
      .to_a

    instrs.each_line do |line|
      count, from, to = line.scan(/\d+/).map(&.[0].to_i)
      stacks[to - 1].concat stacks[from - 1].delete_at(-count..)
    end

    stacks.join(&.last)
  end
end
