require "../support"

solve do
  test <<-INPUT, 35
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    INPUT

  answer do |input|
    maps = input.split("\n\n")
    seeds = maps.shift.scan(/\d+/).map(&.[0].to_i64)
    maps = maps.map { |v| v.split('\n')[1..].map(&.split(' ').map(&.to_i64)) }

    seeds.min_of do |seed|
      maps.reduce(seed) do |s, map|
        map.find { |(dst, src, len)| src <= s < src + len }.try { |(dst, src, _)| dst + s - src } || s
      end
    end
  end
end

solve do
  test <<-INPUT, 46
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    INPUT

  answer do |input|
    maps = input.split("\n\n")
    seed_ranges = maps.shift.scan(/\d+/).map(&.[0].to_i64).in_slices_of(2)
    maps = maps.map { |v| v.split('\n')[1..].map(&.split(' ').map(&.to_i64)) }.reverse!

    (0_i64..).find do |seed|
      seed0 = maps.reduce(seed) do |s, map|
        map.find { |(dst, src, len)| dst <= s < dst + len }.try { |(dst, src, _)| src + s - dst } || s
      end
      seed_ranges.any? { |(lo, hi)| lo <= seed0 < lo + hi }
    end
  end
end
