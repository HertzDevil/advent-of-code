require "../support"

solve do
  test <<-INPUT, 1928
    2333133121414131402
    INPUT

  answer do |input|
    blocks = [] of Int32
    input.each_char_with_index do |ch, i|
      ch.to_i.times { blocks << (i.even? ? i // 2 : -1) }
    end

    i = 0
    while true
      while blocks.last? == -1
        blocks.pop
      end
      while i < blocks.size && blocks[i] != -1
        i += 1
      end
      break if i >= blocks.size

      blocks[i] = blocks.pop
    end

    blocks.each_with_index.sum { |v, i| v.to_i64 * i }
  end
end

solve do
  test <<-INPUT, 2858
    2333133121414131402
    INPUT

  answer do |input|
    pos = 0
    files = [] of {Int32, Int32, Int32}
    gaps = Array.new(10) { [] of Int32 }
    input.each_char_with_index do |ch, i|
      len = ch.to_i
      if i.even?
        raise "shouldn't happen" if len == 0
        files << {i // 2, pos, len}
      elsif len != 0
        gaps[len] << pos
      end
      pos += len
    end
    files.reverse!

    files.each_with_index do |(id, pos, len), i|
      leftmost_gap_pos = nil
      leftmost_gap_len = nil

      (len...gaps.size).each do |gap_len|
        if (l = gaps[gap_len].first?) && l < pos
          unless leftmost_gap_pos && leftmost_gap_pos < l
            leftmost_gap_pos = l
            leftmost_gap_len = gap_len
          end
        end
      end

      if leftmost_gap_pos && leftmost_gap_len
        files[i] = {id, leftmost_gap_pos, len}
        gaps[leftmost_gap_len].shift
        if len < leftmost_gap_len
          g = gaps[leftmost_gap_len - len]
          g.insert(g.bsearch_index { |v| v > leftmost_gap_pos } || g.size, leftmost_gap_pos + len)
        end
      end
    end

    files.sum { |(id, pos, len)| id.to_i64 * len * (2 * pos + len - 1) // 2 }
  end
end
