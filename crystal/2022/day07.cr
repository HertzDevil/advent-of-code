require "../support"

class Directory
  getter entries = {} of String => Int32 | Directory
  getter parent : Directory?

  def initialize(@parent)
  end

  def total_size
    entries.sum { |_, entry| entry.is_a?(Int32) ? entry : entry.total_size }
  end

  def flatten
    entries.each_with_object([self]) do |(_, entry), object|
      object.concat(entry.flatten) if entry.is_a?(Directory)
    end
  end

  def self.parse_cmd(input)
    root = Directory.new(nil)
    pwd = root

    input.each_line.slice_before(&.starts_with?("$")).each do |lines|
      cmd, *outputs = lines
      case cmd
      when "$ ls"
        outputs.each do |output|
          ident, _, name = output.partition(' ')
          pwd.entries[name] = ident == "dir" ? Directory.new(pwd) : ident.to_i
        end
      when "$ cd .."
        pwd = pwd.parent.not_nil!
      when /\$ cd (.+)/
        pwd = pwd.entries[$1].as(Directory) unless $1 == "/"
      end
    end

    root
  end
end

solve do
  test <<-INPUT, 95437
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
    INPUT

  answer do |input|
    Directory.parse_cmd(input)
      .flatten
      .map(&.total_size)
      .select(&.<= 100000)
      .sum
  end
end

solve do
  test <<-INPUT, 24933642
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
    INPUT

  answer do |input|
    root = Directory.parse_cmd(input)
    to_delete = root.total_size - 40000000
    root.flatten
      .map(&.total_size)
      .select(&.>= to_delete)
      .min
  end
end
