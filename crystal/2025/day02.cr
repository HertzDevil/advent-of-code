require "../support"

solve do
  test <<-INPUT, 1227775554
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    INPUT

  answer do |input|
    input.scan(/\d+/).map(&.[0].to_i64).each_slice(2).sum do |(lo, hi)|
      lo_digits = Math.log10(lo).to_i + 1
      hi_digits = Math.log10(hi).to_i + 1

      (lo_digits..hi_digits).sum do |digits|
        next 0_i64 unless digits.even?
        mult = (0...2).sum { |i| 10_i64 ** (digits // 2 * i) }

        lo2 = {lo, 10_i64 ** (digits - 1)}.max
        lo2 += (1_i64 - lo2) % mult - 1

        hi2 = {hi, 10_i64 ** digits - 1}.min
        hi2 -= hi2 % mult

        (lo2 + hi2) * ((hi2 - lo2) // mult + 1) // 2
      end
    end
  end
end

m_solve do
  m_test <<-INPUT, 1227775554_i64
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    INPUT

  m_answer do |input|
    sum = 0_i64
    input.scan(/(\d+)-(\d+)/).each do |m|
      lo = 0_i64 + m[1].to_i # m[1].to_i(:i64)
      hi = 0_i64 + m[2].to_i
      lo_digits = M::Math::Log10.call(lo) + 1
      hi_digits = M::Math::Log10.call(hi) + 1

      (lo_digits..hi_digits).each do |digits|
        if digits % 2 == 0
          mult = 0_i64
          (0...2).each do |i|
            mult += 10_i64 ** (digits // 2 * i)
          end

          lo2 = M::Math::Max.call(lo, 10_i64 ** (digits - 1))
          lo2 += (1_i64 - lo2) % mult - 1

          hi2 = M::Math::Min.call(hi, 10_i64 ** digits - 1)
          hi2 -= hi2 % mult

          sum += (lo2 + hi2) * ((hi2 - lo2) // mult + 1) // 2
        end
      end
    end
    sum
  end
end

solve do
  test <<-INPUT, 4174379265
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    INPUT

  answer do |input|
    input.scan(/\d+/).map(&.[0].to_i64).each_slice(2).sum do |(lo, hi)|
      lo_digits = Math.log10(lo).to_i + 1
      hi_digits = Math.log10(hi).to_i + 1

      (lo_digits..hi_digits).sum do |digits|
        set = Set(Int64).new
        (2..digits).each do |r|
          next unless digits.divisible_by?(r)
          mult = (0...r).sum { |i| 10_i64 ** (digits // r * i) }

          lo2 = {lo, 10_i64 ** (digits - 1)}.max
          lo2 += (1_i64 - lo2) % mult - 1

          hi2 = {hi, 10_i64 ** digits - 1}.min
          hi2 -= hi2 % mult

          (lo2 // mult..hi2 // mult).each do |v|
            set << v * mult
          end
        end
        set.sum
      end
    end
  end
end

m_solve do
  m_test <<-INPUT, 4174379265_i64
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    INPUT

  m_answer do |input|
    sum = 0_i64
    input.scan(/(\d+)-(\d+)/).each do |m|
      lo = 0_i64 + m[1].to_i
      hi = 0_i64 + m[2].to_i
      lo_digits = M::Math::Log10.call(lo) + 1
      hi_digits = M::Math::Log10.call(hi) + 1

      (lo_digits..hi_digits).each do |digits|
        set = [] of _
        (2..digits).each do |r|
          if digits % r == 0
            mult = 0_i64
            (0...r).each do |i|
              mult += 10_i64 ** (digits // r * i)
            end

            lo2 = M::Math::Max.call(lo, 10_i64 ** (digits - 1))
            lo2 += (1_i64 - lo2) % mult - 1

            hi2 = M::Math::Min.call(hi, 10_i64 ** digits - 1)
            hi2 -= hi2 % mult

            (lo2 // mult..hi2 // mult).each do |v|
              set << mult * v
            end
          end
        end
        set.uniq.each { |v| sum += v }
      end
    end
    sum
  end
end
