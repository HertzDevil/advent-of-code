require "../support"

solve do
  test <<-INPUT, 6
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    bggr
    gbbr
    rrbgbr
    ubwu
    bwurrg
    brgr
    bbrgwb
    INPUT

  answer do |input|
    patterns, _, designs = input.partition("\n\n")
    patterns = patterns.split(", ")
    patterns2 = Regex.new("^(?:#{patterns.select(&.size.<=(2)).join("|")}){2,}$")
    patterns.reject!(&.matches?(patterns2))
    re = Regex.new("^(?:#{patterns.join("|")})+$")
    designs.each_line.count &.matches?(re)
  end
end

solve do
  test <<-INPUT, 16
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    bggr
    gbbr
    rrbgbr
    ubwu
    bwurrg
    brgr
    bbrgwb
    INPUT

  answer do |input|
    patterns, _, designs = input.partition("\n\n")
    patterns = patterns.split(", ")

    designs.each_line.sum do |line|
      totals = [1_i64]
      line.each_char_with_index do |ch, i|
        totals << patterns.sum { |v| s = i + 1 - v.size; s >= 0 && line[s, v.size] == v ? totals[s] : 0_i64 }
      end
      totals.last
    end
  end
end
