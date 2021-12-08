require "../support"
require "bit_array"

{% if true %}
  struct BitArray
    # :inherit:
    def fill(value : Bool) : self
      return self if size == 0

      if size <= 32
        @bits.value = value ? ~(UInt32::MAX << size) : 0_u32
      elsif size <= 64
        @bits.as(UInt64*).value = value ? ~(UInt64::MAX << size) : 0_u64
      else
        to_slice.fill(value ? 0xFF_u8 : 0x00_u8)
        clear_unused_bits if value
      end

      self
    end

    # :inherit:
    def fill(value : Bool, start : Int, count : Int) : self
      start, count = normalize_start_and_count(start, count)
      return self if count <= 0
      bytes = to_slice

      start_bit_index, start_sub_index = start.divmod(8)
      end_bit_index, end_sub_index = (start + count - 1).divmod(8)

      if start_bit_index == end_bit_index
        # same UInt8, don't perform the loop at all
        mask = uint8_mask(start_sub_index, end_sub_index)
        value ? (bytes[start_bit_index] |= mask) : (bytes[start_bit_index] &= ~mask)
      else
        mask = uint8_mask(start_sub_index, 7)
        value ? (bytes[start_bit_index] |= mask) : (bytes[start_bit_index] &= ~mask)

        bytes[start_bit_index + 1..end_bit_index - 1].fill(value ? 0xFF_u8 : 0x00_u8)

        mask = uint8_mask(0, end_sub_index)
        value ? (bytes[end_bit_index] |= mask) : (bytes[end_bit_index] &= ~mask)
      end

      self
    end

    # returns (1 << from) | (1 << (from + 1)) | ... | (1 << to)
    @[AlwaysInline]
    private def uint8_mask(from, to)
      (Int8::MIN >> (to - from)).to_u8! >> (7 - to)
    end

    def count(item : Bool) : Int32
      ones_count = Slice.new(@bits, malloc_size).sum(&.popcount)
      item ? ones_count : @size - ones_count
    end
  end
{% end %}

solve do
  answer do |input|
    lights = BitArray.new(1000 * 1000)
    input.each_line do |line|
      x1, y1, x2, y2 = line.match(/(\d+),(\d+) through (\d+),(\d+)\z/).not_nil!.captures.map(&.not_nil!.to_i)
      case line
      when /\Atoggle/  ; (y1..y2).each { |y| lights.toggle(y * 1000 + x1, x2 - x1 + 1) }
      when /\Aturn on/ ; (y1..y2).each { |y| lights.fill(true, y * 1000 + x1, x2 - x1 + 1) }
      when /\Aturn off/; (y1..y2).each { |y| lights.fill(false, y * 1000 + x1, x2 - x1 + 1) }
      end
    end
    lights.count(true)
  end
end

solve do
  answer do |input|
    lights = Array(Int32).new(1000 * 1000, 0)
    input.each_line do |line|
      x1, y1, x2, y2 = line.match(/(\d+),(\d+) through (\d+),(\d+)\z/).not_nil!.captures.map(&.not_nil!.to_i)
      case line
      when /\Atoggle/  ; (y1..y2).each { |y| (x1..x2).each { |x| lights[y * 1000 + x] += 2 } }
      when /\Aturn on/ ; (y1..y2).each { |y| (x1..x2).each { |x| lights[y * 1000 + x] += 1 } }
      when /\Aturn off/; (y1..y2).each { |y| (x1..x2).each { |x| lights[y * 1000 + x] = {lights[y * 1000 + x] - 1, 0}.max } }
      end
    end
    lights.sum
  end
end
