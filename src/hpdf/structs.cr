module Hpdf
  struct Point
    property x, y

    def initialize(@x : Float32, @y : Float32)
    end

    def initialize(point : LibHaru::Point)
      @x = point.x.to_f32
      @y= point.y.to_f32
    end
  end

  struct Size
    property width, height

    def initialize(@width : UInt32, @height : UInt32)
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
end
