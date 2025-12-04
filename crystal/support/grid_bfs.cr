require "./point"

module Neighborhood(P, V)
  abstract def neighbors(v : P, & : P ->)
  abstract def sphere(v : P, radius : Int, & : P ->)
  abstract def norm(v : V) : Int

  def neighbors(v : P) : Array(P)
    ws = [] of P
    neighbors(v) { |w| ws << w }
    ws
  end

  def sphere(v : P, radius : Int) : Array(P)
    ws = [] of P
    sphere(v, radius) { |w| ws << w }
    ws
  end

  def distance(v : P, w : P) : Int
    norm(v - w)
  end
end

module VonNeumann2D
  extend Neighborhood(Point2D, Vector2D)

  OFFSETS = [
    {+0, -1},
    {-1, +0},
    {+1, +0},
    {+0, +1},
  ]

  def self.neighbors(v : Point2D, & : Point2D ->)
    {% for v in OFFSETS %}
      yield v + Vector2D.new({{ v.splat }})
    {% end %}
  end

  def self.sphere(v : Point2D, radius : Int, & : Point2D ->)
    if radius <= 0
      yield v
    else
      (0...radius).each { |i| yield v + Vector2D.new(i, i - radius) }
      (0...radius).each { |i| yield v + Vector2D.new(radius - i, i) }
      (0...radius).each { |i| yield v + Vector2D.new(-i, radius - i) }
      (0...radius).each { |i| yield v + Vector2D.new(i - radius, -i) }
    end
  end

  def self.norm(v : Vector2D) : Int
    v.to_tuple.sum(&.abs)
  end
end

module Moore2D
  extend Neighborhood(Point2D, Vector2D)

  OFFSETS = [
    {-1, -1},
    {+0, -1},
    {+1, -1},
    {-1, +0},
    {+1, +0},
    {-1, +1},
    {+0, +1},
    {+1, +1},
  ]

  def self.neighbors(v : Point2D, & : Point2D ->)
    {% for v in OFFSETS %}
      yield v + Vector2D.new({{ v.splat }})
    {% end %}
  end

  def self.sphere(v : Point2D, radius : Int, & : Point2D ->)
    if radius <= 0
      yield v
    else
      (-radius...radius).each { |i| yield v + Vector2D.new(i, -radius) }
      (-radius...radius).each { |i| yield v + Vector2D.new(radius, -i) }
      (-radius...radius).each { |i| yield v + Vector2D.new(-i, radius) }
      (-radius...radius).each { |i| yield v + Vector2D.new(-radius, -i) }
    end
  end

  def self.norm(v : Vector2D) : Int
    v.to_tuple.max_of(&.abs)
  end
end

class GridBFS(T, N, V)
  @path_proc = Proc(T, V, T, V, Int32, Int32, Bool).new { |src_v, src, dst_v, dst, d_old, d| false }
  @finish_proc = Proc(Hash(T, Int32), Bool).new { |reachable| false }

  def initialize(@grid : Hash(T, V), @neighborhood : N) # N <= Neighborhood(T, _)
  end

  def path(&@path_proc : T, V, T, V, Int32, Int32 -> Bool)
    self
  end

  def finish(&@finish_proc : Hash(T, Int32) -> Bool)
    self
  end

  def run(v0 : T)
    reachable = {v0 => 0}
    frontier = [v0]

    (1..).each do |d|
      new_frontier = [] of Point2D
      frontier.each do |v1|
        src = @grid[v1]
        @neighborhood.neighbors(v1) do |v2|
          next if reachable.has_key?(v2)
          next unless dst = @grid[v2]?
          next unless @path_proc.call(v1, src, v2, dst, reachable[v1], d)
          reachable[v2] = d
          new_frontier << v2
        end
      end
      frontier.concat(new_frontier).uniq!.reject! do |v1|
        @neighborhood.neighbors(v1).all? { |v2| reachable.has_key?(v2) }
      end
      break d if @finish_proc.call(reachable)
    end
  end
end
