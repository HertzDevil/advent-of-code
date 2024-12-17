require "../support"

BITS_AND_MASKS = [
  [
    {0b101000100, 0b111000111},
    {0b1110110, 0b1110111},
    {0b000001, 0b111111},
    {0b1000000101, 0b1110000111},
    {0b11000111, 0b11100111},
  ],
  [
    {0b00000, 0b11111},
    {0b100000100, 0b111000111},
    {0b010, 0b111},
    {0b1100110, 0b1110111},
    {0b001001, 0b111111},
    {0b1010000101, 0b1110000111},
    {0b11100111, 0b11100111},
  ],
  [
    {0b111000100, 0b111000111},
    {0b1010110, 0b1110111},
    {0b010001, 0b111111},
    {0b1100000101, 0b1110000111},
    {0b10000111, 0b11100111},
  ],
  [
    {0b01000, 0b11111},
    {0b110000100, 0b111000111},
    {0b1000110, 0b1110111},
    {0b011001, 0b111111},
    {0b1110000101, 0b1110000111},
    {0b0011, 0b1111},
    {0b10100111, 0b11100111},
  ],
  [
    {0b001000100, 0b111000111},
    {0b0110110, 0b1110111},
    {0b100001, 0b111111},
    {0b0000000101, 0b1110000111},
    {0b01000111, 0b11100111},
  ],
  [
    {0b10000, 0b11111},
    {0b000000100, 0b111000111},
    {0b0100110, 0b1110111},
    {0b101001, 0b111111},
    {0b0010000101, 0b1110000111},
    {0b01100111, 0b11100111},
  ],
  [
    {0b011000100, 0b111000111},
    {0b0010110, 0b1110111},
    {0b110001, 0b111111},
    {0b0100000101, 0b1110000111},
    {0b00000111, 0b11100111},
  ],
  [
    {0b11000, 0b11111},
    {0b010000100, 0b111000111},
    {0b0000110, 0b1110111},
    {0b111001, 0b111111},
    {0b0110000101, 0b1110000111},
    {0b1011, 0b1111},
    {0b00100111, 0b11100111},
  ],
]
BITS_AND_MASKS.each &.sort_by! &.first

def dfs(target, n, all_bits = 0_i64, all_mask = 0_i64)
  return all_bits if n < 0

  output_bits = (target >> n) & 7
  BITS_AND_MASKS[output_bits].each do |(bits, mask)|
    bits = bits.to_i64! << n
    mask = mask.to_i64! << n
    common_mask = mask & all_mask
    if (all_bits & common_mask) == (bits & common_mask)
      candidate = dfs(target, n - 3, all_bits | bits, all_mask | mask)
      return candidate if candidate
    end
  end
end

solve do
  test <<-INPUT, "4,6,3,5,6,3,5,2,1,0"
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    INPUT

  test <<-INPUT, "0,3,5,4,3,0"
    Register A: 117440
    Register B: 0
    Register C: 0

    Program: 0,3,5,4,3,0
    INPUT

  answer do |input|
    a, b, c, *program = input.scan(/\d+/).map(&.[0].to_i)
    output = [] of Int32

    pc = 0
    while pc < program.size - 1
      instr = program[pc]
      op = program[pc + 1]

      arg = case op
            when 4 then a
            when 5 then b
            when 6 then c
            else
              op
            end

      case instr
      when 0
        a >>= arg
      when 1
        b ^= op
      when 2
        b = arg & 7
      when 3
        if a != 0
          pc = op
          next
        end
      when 4
        b ^= c
      when 5
        output << (arg & 7)
      when 6
        b = a >> arg
      when 7
        c = a >> arg
      end

      pc += 2
    end

    output.join(',')
  end
end

solve do
  answer do |input|
    # 2,4,1,2,7,5,4,1,1,3,5,5,0,3,3,0

    # 00    b = a & 7
    # 02    b ^= 2
    # 04    c = a >> b
    # 06    b ^= c
    # 08    b ^= 3
    # 10    output << (b & 7)
    # 12    a >>= 3
    # 14    pc = 0 if a != 0

    # while true
    #   output << (a[0..2] ^ 1 ^ a[(a[0..2] ^ 2)..((a[0..2] ^ 2) + 2)])
    #   a = a[3..]
    #   break if a == 0
    # end

    program = input.scan(/\d+/)[3..].map(&.[0].to_i)
    n = (program.size - 1) * 3
    target = 0_i64
    program.each_with_index do |v, i|
      target |= v.to_i64 << (i * 3)
    end
    dfs(target, n)
  end
end
