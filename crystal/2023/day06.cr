require "../support"
require "big"

solve do
  test <<-INPUT, 288
    Time:      7  15   30
    Distance:  9  40  200
    INPUT

  answer do |input|
    times, distances = input.split('\n').map(&.partition(':')[2].split(' ', remove_empty: true).map(&.to_i64))
    races = times.zip(distances)
    races.product do |t, d|
      # (0_i64..t).count { |i| i * (t - i) > d }
      lo = ((t - Math.sqrt(t * t - d * 4)) / 2.0).floor.to_i64 + 1
      hi = ((t + Math.sqrt(t * t - d * 4)) / 2.0).ceil.to_i64 - 1
      hi - lo + 1
    end
  end
end

solve do
  test <<-INPUT, 71503
    Time:      7  15   30
    Distance:  9  40  200
    INPUT

  answer do |input|
    t, d = input.split('\n').map(&.partition(':')[2].gsub(' ', "").to_i64)
    # (0_i64..t).count { |i| i * (t - i) > d }
    lo = ((t - Math.sqrt(t * t - d * 4)) / 2.0).floor.to_i64 + 1
    hi = ((t + Math.sqrt(t * t - d * 4)) / 2.0).ceil.to_i64 - 1
    hi - lo + 1
  end
end
