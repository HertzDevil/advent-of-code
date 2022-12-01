require "../support"
require "bit_array"

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
