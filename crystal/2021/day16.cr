require "../support"
require "bit_array"

def get_int(stream, n)
  x = 0
  n.times do
    x <<= 1
    b = stream.next
    return nil if b.is_a?(Iterator::Stop)
    x |= 1 if b
  end
  x
end

record Literal, version : Int32, type_id : Int32, value : Int64 do
  def total_version : Int32
    @version
  end

  def transform : Int64
    @value
  end
end

record Operator, version : Int32, type_id : Int32, length_type : Int32, count : Int32, subpackets : Array(Packet) do
  def total_version : Int32
    @subpackets.sum(@version, &.total_version)
  end

  def transform : Int64
    case type_id
    when 0
      @subpackets.sum(0_i64, &.transform)
    when 1
      @subpackets.product(1_i64, &.transform)
    when 2
      @subpackets.min_of(&.transform)
    when 3
      @subpackets.max_of(&.transform)
    when 5
      raise "" unless @subpackets.size == 2
      @subpackets[0].transform > @subpackets[1].transform ? 1_i64 : 0_i64
    when 6
      raise "" unless @subpackets.size == 2
      @subpackets[0].transform < @subpackets[1].transform ? 1_i64 : 0_i64
    when 7
      raise "" unless @subpackets.size == 2
      @subpackets[0].transform == @subpackets[1].transform ? 1_i64 : 0_i64
    else
      raise "unknown operator"
    end
  end
end

alias Packet = Literal | Operator

def parse(stream)
  version = get_int(stream, 3)
  return nil unless version
  type_id = get_int(stream, 3)
  return nil unless type_id

  case type_id
  when 0b100
    x = 0_i64
    while true
      cont = stream.next
      return nil if cont.is_a?(Iterator::Stop)
      x <<= 4
      y = get_int(stream, 4)
      return nil unless y
      x |= y
      break unless cont
    end
    Literal.new(version: version, type_id: type_id, value: x)
  else
    case stream.next
    in false
      total_length = get_int(stream, 15)
      return nil unless total_length
      packet = Operator.new(version: version, type_id: type_id, length_type: 0, count: total_length, subpackets: [] of Packet)
      delimited_stream = stream.first(total_length).to_a.each
      while subpacket = parse(delimited_stream)
        packet.subpackets << subpacket
      end
      packet
    in true
      packet_count = get_int(stream, 11)
      return nil unless packet_count
      packet = Operator.new(version: version, type_id: type_id, length_type: 1, count: packet_count, subpackets: [] of Packet)
      packet_count.times do
        packet.subpackets << parse(stream).not_nil!
      end
      packet
    in Iterator::Stop
    end
  end
end

solve do
  test "D2FE28", 6
  test "38006F45291200", 9
  test "EE00D40C823060", 14

  answer do |input|
    bits = BitArray.new(input.size * 4)
    input.each_char_with_index do |ch, i|
      b = ch.to_i(16)
      bits[i * 4 + 0] = b & 0b1000 != 0
      bits[i * 4 + 1] = b & 0b0100 != 0
      bits[i * 4 + 2] = b & 0b0010 != 0
      bits[i * 4 + 3] = b & 0b0001 != 0
    end
    parse(bits.each).not_nil!.total_version
  end
end

solve do
  test "C200B40A82", 3
  test "04005AC33890", 54
  test "880086C3E88112", 7
  test "CE00C43D881120", 9
  test "D8005AC2A8F0", 1
  test "F600BC2D8F", 0
  test "9C005AC2F8F0", 0
  test "9C0141080250320F1802104A08", 1

  answer do |input|
    bits = BitArray.new(input.size * 4)
    input.each_char_with_index do |ch, i|
      b = ch.to_i(16)
      bits[i * 4 + 0] = b & 0b1000 != 0
      bits[i * 4 + 1] = b & 0b0100 != 0
      bits[i * 4 + 2] = b & 0b0010 != 0
      bits[i * 4 + 3] = b & 0b0001 != 0
    end
    parse(bits.each).not_nil!.transform
  end
end
