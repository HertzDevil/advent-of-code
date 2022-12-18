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

    def *(other : T) : {{ name }}
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
  FROM_CHAR = {
    'U' => Vector2D.new(+0, -1),
    'D' => Vector2D.new(+0, +1),
    'L' => Vector2D.new(-1, +0),
    'R' => Vector2D.new(+1, +0),

    'N' => Vector2D.new(+0, -1),
    'S' => Vector2D.new(+0, +1),
    'W' => Vector2D.new(-1, +0),
    'E' => Vector2D.new(+1, +0),
  }

  FROM_STR = {
    "U" => Vector2D.new(+0, -1),
    "D" => Vector2D.new(+0, +1),
    "L" => Vector2D.new(-1, +0),
    "R" => Vector2D.new(+1, +0),

    "N" => Vector2D.new(+0, -1),
    "S" => Vector2D.new(+0, +1),
    "W" => Vector2D.new(-1, +0),
    "E" => Vector2D.new(+1, +0),
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
end

def_vector Vector3D, Int32, [x, y, z]
def_point Point3D, Int32, [x, y, z]
def_affine_methods Point3D, Vector3D, Int32, [x, y, z]
