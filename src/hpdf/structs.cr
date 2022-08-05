module Hpdf
  struct Point
    property x, y

    def initialize(@x : Float32, @y : Float32)
    end

    def initialize(point : LibHaru::Point)
      @x = point.x.to_f32
      @y = point.y.to_f32
    end
  end

  struct Size
    property width, height

    def initialize(@width : UInt32, @height : UInt32)
    end
  end

  struct Rectangle
    property x, y, width, height

    def initialize(@x : Float32, @y : Float32, @width : Float32, @height : Float32)
    end

    def initialize()
      @x = 0
      @y = 0
      @width = 0
      @height = 0
    end

    def to_unsafe
      r = LibHaru::Rect.new
      r.left = left
      r.right = right
      r.bottom = bottom
      r.top = top
      r
    end

    def left
      @x
    end

    def right
      @x + @width
    end

    def bottom
      @y
    end

    def top
      @y + @height
    end

    def left=(left : Float32)
      @x = left
    end

    # will be converted to `width`, so `left` has to be set before
    def right=(right : Float32)
      @width = right - left
    end

    def bottom=(bottom : Float32)
      @y = bottom
    end

    # will be converted to `height`, so `bottom` has to be set before
    def top=(top : Float32)
      @height = top - bottom
    end
  end

  struct MeasuredText
    # the byte length which can be included within the specified width
    getter len_included : UInt32
    # the real widths of the text is set. An application can set it to NULL if it is unnecessary
    getter real_width : Float32

    def initialize(@len_included, @real_width)
    end
  end

  struct RGB
    property r, g, b

    def initialize(@r : Float32, @g : Float32, @b : Float32)
    end

    def initialize(point : LibHaru::RGB)
      @r = point.r.to_f32
      @g = point.g.to_f32
      @b = point.b.to_f32
    end
  end

  struct CMYK
    property c, m, y, k

    def initialize(@c : Float32, @m : Float32, @y : Float32, @k : Float32)
    end

    def initialize(point : LibHaru::CMYK)
      @c = point.c.to_f32
      @m = point.m.to_f32
      @y = point.y.to_f32
      @k = point.k.to_f32
    end
  end
end
