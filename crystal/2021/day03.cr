require "../support"

solve do
  test <<-INPUT, 198
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    INPUT

  answer &.lines
    .map(&.chars)
    .transpose
    .map { |v| v.count('1') >= v.count('0') ? {1, 0} : {0, 1} }
    .transpose
    .map(&.join.to_i(2))
    .product
end

solve do
  test <<-INPUT, 230
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    INPUT

  answer do |input|
    o = input.lines
    co2 = input.lines

    (0...o[0].size).each do |i|
      if o.size > 1
        o_ch = o.count(&.[i].== '1') >= o.size / 2 ? '1' : '0'
        o.select! &.[i].== o_ch
      end

      if co2.size > 1
        co2_ch = co2.count(&.[i].== '1') >= co2.size / 2 ? '1' : '0'
        co2.reject! &.[i].== co2_ch
      end
    end

    o[0].to_i(2) * co2[0].to_i(2)
  end
end
