private macro def_vector(name, coord_type, members)
  record {{ name }}{% for m in members %}, {{ m.id }} : {{ coord_type }}{% end %} do
    def inspect(io : IO) : Nil
      io << '<'
      {% for m, i in members %}\
        io << @{{ m }} << {{ i == members.size - 1 ? '>' : ", " }}
      {% end %}
    end

    def to_tuple : Tuple
      Tuple.new(
        {% for m in members %} @{{ m }}, {% end %}
      )
    end

    def to_named : NamedTuple
      NamedTuple.new(
        {% for m in members %} {{ m.stringify }}: @{{ m }}, {% end %}
      )
    end

    def self.zero : {{ name }}
      new({{ members.map { "#{coord_type}.zero".id }.splat }})
    end

    {% for axis in members %}
      def reflect(*, {{ axis }} : {{ coord_type }}) : {{ name }}
        {{ name }}.new(
          {% for m in members %} {% if m == axis %} {{ m }} * 2 -{% end %} @{{ m }}, {% end %}
        )
      end
    {% end %}

    def +(other : {{ name }}) : {{ name }}
      {{ name }}.new(
        {% for m in members %} @{{ m }} + other.{{ m }}, {% end %}
      )
    end

    def -(other : {{ name }}) : {{ name }}
      {{ name }}.new(
        {% for m in members %} @{{ m }} - other.{{ m }}, {% end %}
      )
    end

    def *(other : Int) : {{ name }}
      {{ name }}.new(
        {% for m in members %} @{{ m }} * other, {% end %}
      )
    end

    def - : {{ name }}
      {{ name }}.new(
        {% for m in members %} -@{{ m }}, {% end %}
      )
    end

    def invert : {{ name }}
      {{ name }}.new(
        {% for m in members %} -@{{ m }}, {% end %}
      )
    end
  end

  struct {{ coord_type }}
    def *(other : {{ name }}) : {{ name }}
      {{ name }}.new(
        {% for m in members %} self * other.{{ m }}, {% end %}
      )
    end
  end
end

private macro def_point(name, coord_type, members)
  record {{ name }}{% for m in members %}, {{ m.id }} : {{ coord_type }}{% end %} do
    def inspect(io : IO) : Nil
      io << '('
      {% for m, i in members %}\
        io << @{{ m }} << {{ i == members.size - 1 ? ')' : ", " }}
      {% end %}
    end

    def to_tuple : Tuple
      Tuple.new(
        {% for m in members %} @{{ m }}, {% end %}
      )
    end

    def to_named : NamedTuple
      NamedTuple.new(
        {% for m in members %} {{ m.stringify }}: @{{ m }}, {% end %}
      )
    end

    def self.zero : {{ name }}
      new({{ members.map { "#{coord_type}.zero".id }.splat }})
    end

    {% for axis in members %}
      def reflect(*, {{ axis }} : {{ coord_type }}) : {{ name }}
        {{ name }}.new(
          {% for m in members %} {% if m == axis %} {{ m }} * 2 -{% end %} @{{ m }}, {% end %}
        )
      end
    {% end %}

    def invert : {{ name }}
      {{ name }}.new(
        {% for m in members %} -@{{ m }}, {% end %}
      )
    end
  end
end

# p + v = p
# p - v = p
# p - p = v
# v + p = p
private macro def_affine_methods(point, vector, coord, members)
  struct {{ point }}
    def +(other : {{ vector }}) : {{ point }}
      {{ point }}.new(
        {% for m in members %} @{{ m }} + other.{{ m }}, {% end %}
      )
    end

    def -(other : {{ vector }}) : {{ point }}
      {{ point }}.new(
        {% for m in members %} @{{ m }} - other.{{ m }}, {% end %}
      )
    end

    def -(other : {{ point }}) : {{ vector }}
      {{ vector }}.new(
        {% for m in members %} @{{ m }} - other.{{ m }}, {% end %}
      )
    end
  end

  struct {{ vector }}
    def +(other : {{ point }}) : {{ point }}
      {{ point }}.new(
        {% for m in members %} @{{ m }} + other.{{ m }}, {% end %}
      )
    end
  end
end

def_vector Vector2D, Int32, [x, y]
def_point Point2D, Int32, [x, y]
def_affine_methods Point2D, Vector2D, Int32, [x, y]

struct Vector2D
  NORTH = new(+0, -1)
  SOUTH = new(+0, +1)
  WEST  = new(-1, +0)
  EAST  = new(+1, +0)

  FROM_CHAR = {
    'U' => NORTH,
    'D' => SOUTH,
    'L' => WEST,
    'R' => EAST,

    'N' => NORTH,
    'S' => SOUTH,
    'W' => WEST,
    'E' => EAST,
  }

  FROM_STR = {
    "U" => NORTH,
    "D" => SOUTH,
    "L" => WEST,
    "R" => EAST,

    "N" => NORTH,
    "S" => SOUTH,
    "W" => WEST,
    "E" => EAST,
  }

  def cw : Vector2D
    Vector2D.new(x: -@y, y: @x)
  end

  def ccw : Vector2D
    Vector2D.new(x: @y, y: -@x)
  end
end

struct Point2D
  def cw : Point2D
    Point2D.new(-@y, @x)
  end

  def ccw : Point2D
    Point2D.new(@y, -@x)
  end

  def self.grid_from_input(input : String, & : Char -> T) forall T
    grid = Hash(Point2D, typeof(begin
      x = uninitialized T
      x.is_a?(Enumerable::Chunk::Drop) ? raise("") : x
    end)).new(initial_capacity: input.size)

    input.each_line.with_index do |line, y|
      line.each_char_with_index do |ch, x|
        cell = yield ch
        unless cell.is_a?(Enumerable::Chunk::Drop)
          grid[Point2D.new(x, y)] = cell
        end
      end
    end

    grid
  end

  def self.grid_from_input(input : String) : Hash(Point2D, Char)
    grid_from_input(input, &.itself)
  end
end

def_vector Vector3D, Int32, [x, y, z]
def_point Point3D, Int32, [x, y, z]
def_affine_methods Point3D, Vector3D, Int32, [x, y, z]
