record Point2D, x : Int32, y : Int32

module Neighborhood(T)
  abstract def neighbors(v : T, & : T ->)
  abstract def distance(v : T, w : T) : Int

  def neighbors(v : T) : Array(T)
    ws = [] of T
    neighbors(v) { |w| ws << w }
    ws
  end
end

module VonNeumann2D
  extend Neighborhood(Point2D)

  def self.neighbors(v : Point2D, & : Point2D ->)
    yield Point2D.new(x: v.x + 0, y: v.y - 1)
    yield Point2D.new(x: v.x - 1, y: v.y + 0)
    yield Point2D.new(x: v.x + 1, y: v.y + 0)
    yield Point2D.new(x: v.x + 0, y: v.y + 1)
  end

  def self.distance(v : Point2D, w : Point2D) : Int
    (v.x - w.x).abs + (v.y - w.y).abs
  end
end

module Moore2D
  extend Neighborhood(Point2D)

  def self.neighbors(v : Point2D, & : Point2D ->)
    yield Point2D.new(x: v.x - 1, y: v.y - 1)
    yield Point2D.new(x: v.x + 0, y: v.y - 1)
    yield Point2D.new(x: v.x + 1, y: v.y - 1)
    yield Point2D.new(x: v.x - 1, y: v.y + 0)
    yield Point2D.new(x: v.x + 1, y: v.y + 0)
    yield Point2D.new(x: v.x - 1, y: v.y + 1)
    yield Point2D.new(x: v.x + 0, y: v.y + 1)
    yield Point2D.new(x: v.x + 1, y: v.y + 1)
  end

  def self.distance(v : Point2D, w : Point2D) : Int
    {(v.x - w.x).abs, (v.y - w.y).abs}.max
  end
end

class GridBFS(T, N, V)
  @path_proc = Proc(T, V, T, V, Int32, Int32, Bool).new { |src_v, src, dst_v, dst, d_old, d| false }
  @finish_proc = Proc(Hash(T, Int32), Bool).new { |reachable| false }

  def initialize(@grid : Hash(T, V), @neighborhood : N) # N <= Neighborhood(T)
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