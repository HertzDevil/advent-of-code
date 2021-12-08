require "../support"

# abc.efg 6
# ..c..f. 2
# a.cde.g 5
# a.cd.fg 5
# .bcd.f. 4
# ab.d.fg 5
# ab.defg 6
# a.c..f. 3
# abcdefg 7
# abcd.fg 6
#
# 8687497

solve do
  test <<-INPUT, 26
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    INPUT

  answer &.each_line
    .sum(&.partition(" | ")[2]
      .split(' ')
      .count &.size.in?(2, 3, 4, 7))
end

NUMBERS = {
  "abcefg"  => "0",
  "cf"      => "1",
  "acdeg"   => "2",
  "acdfg"   => "3",
  "bcdf"    => "4",
  "abdfg"   => "5",
  "abdefg"  => "6",
  "acf"     => "7",
  "abcdefg" => "8",
  "abcdfg"  => "9",
}

solve do
  test <<-INPUT, 61229
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    INPUT

  answer &.each_line.sum do |line|
    inputs, _, outputs = line.partition(" | ")
    inputs = inputs.split(' ')
    outputs = outputs.split(' ')
    input_totals = inputs.join.chars.tally

    one = inputs.find(&.size.== 2).not_nil!
    seven = inputs.find(&.size.== 3).not_nil!
    four = inputs.find(&.size.== 4).not_nil!

    a_mapped = (seven.chars - one.chars).first
    b_mapped = input_totals.key_for(6)
    e_mapped = input_totals.key_for(4)
    f_mapped = input_totals.key_for(9)
    c_mapped = (one.chars - [f_mapped]).first
    d_mapped = (four.chars - [b_mapped, c_mapped, f_mapped]).first
    g_mapped = ("abcdefg".chars - [a_mapped, b_mapped, c_mapped, d_mapped, e_mapped, f_mapped]).first
    mapped = "#{a_mapped}#{b_mapped}#{c_mapped}#{d_mapped}#{e_mapped}#{f_mapped}#{g_mapped}"

    outputs.map! do |output|
      NUMBERS[output.tr(mapped, "abcdefg").chars.sort.join]
    end
    outputs.join.to_i
  end
end
