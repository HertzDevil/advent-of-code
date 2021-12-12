require "../support"

solve do
  test <<-INPUT, 10
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    INPUT

  test <<-INPUT, 19
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    INPUT

  test <<-INPUT, 226
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    INPUT

  answer do |input|
    cave = {} of String => Set(String)
    input.each_line do |line|
      a, b = line.match(/\A([A-Za-z]+)-([A-Za-z]+)\z/).not_nil!.captures.map(&.not_nil!)
      cave[a] ||= Set(String).new
      cave[b] ||= Set(String).new
      cave[a] << b
      cave[b] << a
    end

    count = 0
    paths = [%w(start)]
    while path = paths.pop?
      cave[path.last].each do |v|
        if v == "end"
          count += 1
        elsif v.matches?(/\A[A-Z]+\z/) || !path.includes?(v)
          paths << (path.dup << v)
        end
      end
    end

    count
  end
end

solve do
  test <<-INPUT, 36
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    INPUT

  test <<-INPUT, 103
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    INPUT

  test <<-INPUT, 3509
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    INPUT

  answer do |input|
    cave = {} of String => Set(String)
    input.each_line do |line|
      a, b = line.match(/\A([A-Za-z]+)-([A-Za-z]+)\z/).not_nil!.captures.map(&.not_nil!)
      cave[a] ||= Set(String).new
      cave[b] ||= Set(String).new
      cave[a] << b unless b == "start"
      cave[b] << a unless a == "start"
    end

    count = 0
    paths = [{ %w(start), nil.as(String?) }]
    while path_info = paths.pop?
      path, repeated = path_info
      cave[path.last].each do |v|
        if v == "end"
          count += 1
        elsif v.matches?(/\A[A-Z]+\z/) || !path.includes?(v)
          paths << {(path.dup << v), repeated}
        elsif repeated.nil?
          paths << {(path.dup << v), v}
        end
      end
    end

    count
  end
end
