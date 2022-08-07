module Hpdf
  # Raw contains helpers to create in memory gray, rgb and cmyk images.
  #
  # Example:
  # ```
  # pdf = Hpdf::Doc.new
  # pdf.page do
  #   gi = Hpdf::Raw::GrayImage.new(4, 4)
  #   gi[0, 1] = 0x7f
  #   gi[3, 1] = 0x7f
  #   gi[1, 2] = 0xff
  #   gi[2, 2] = 0xff
  #   img = pdf.load_raw_image_from_mem gi
  #   draw_image img, 100, 100, 100, 100
  # end
  # ```
  module Raw
    abstract class Image
      getter width
      getter height
      getter color_space

      # create a new in-memory image
      #
      # * *width* the width of the image.
      # * *height* the height of the image.
      # * *color_space* `ColorSpace::DeviceGray` or `ColorSpace::DeviceRgb`
      #   or `ColorSpace::DeviceCmyk` is allowed.
      def initialize(@width : UInt32, @height : UInt32, @color_space : ColorSpace)
        case @color_space
        when ColorSpace::DeviceGray
          @buf = Array(UInt8).new(@width * @height, 0)
        when ColorSpace::DeviceRgb
          @buf = Array(UInt8).new(@width * @height * 3, 0)
        when ColorSpace::DeviceCmyk
          @buf = Array(UInt8).new(@width * @height * 4, 0)
        else
          raise ArgumentError.new("invalid color_space was used: #{@color_space}")
        end
      end

      def to_unsafe
        @buf.to_unsafe
      end
    end

    # create a new in-memory image with gray scale. Import using `Doc#load_raw_image_from_mem`
    class GrayImage < Image
      def initialize(width : UInt32, height : UInt32)
        super width, height, ColorSpace::DeviceGray
      end

      # sets the gray value at `x` and `y` via `scale`.
      # `0xff` is white and `0x00` is black.
      def gray_at(x : UInt32, y : UInt32, scale : UInt8)
        @buf[y*@width+x] = scale
      end

      # sets the gray value at `x` and `y` via `scale`.
      # `0xff` is white and `0x00` is black.
      def []=(x : Number, y : Number, scale : Number)
        gray_at(x.to_u32, y.to_u32, scale.to_u8)
      end
    end

    # Color mixed of red, green and blue. Import using `Doc#load_raw_image_from_mem`
    struct RgbColor
      property red, green, blue

      def initialize(@red : UInt8, @green : UInt8, @blue : UInt8)
      end

      def initialize(red : Number, green : Number, blue : Number)
        @red = red.to_u8
        @green = green.to_u8
        @blue = blue.to_u8
      end
    end

    # create a new in-memory RGB image
    class RgbImage < Image

      def initialize(width : UInt32, height : UInt32)
        super width, height, ColorSpace::DeviceRgb
      end

      # sets the rgb value at `x` and `y`.
      def rgb_at(x : UInt32, y : UInt32, red : UInt8, green : UInt8, blue : UInt8)
        @buf[y*@width*3+x*3] = red
        @buf[y*@width*3+x*3+1] = green
        @buf[y*@width*3+x*3+2] = blue
      end

      def []=(x : Number, y : Number, color : RgbColor)
        rgb_at(x.to_u32, y.to_u32, color.red, color.green, color.blue)
      end
    end

    # Color mixed of cyan, magenta, yellow and black. Import using `Doc#load_raw_image_from_mem`
    struct CmykColor
      property cyan, magenta, yellow, black

      def initialize(@cyan : UInt8, @magenta : UInt8, @yellow : UInt8, @black : UInt8)
      end

      def initialize(cyan : Number, magenta : Number, yellow : Number, black : Number)
        @cyan = cyan.to_u8
        @magenta = magenta.to_u8
        @yellow = yellow.to_u8
        @black = black.to_u8
      end
    end

    # create a new in-memory CMYK image. Import using `Doc#load_raw_image_from_mem`
    class CmykImage < Image

      def initialize(width : UInt32, height : UInt32)
        super width, height, ColorSpace::DeviceCmyk
      end

      # sets the rgb value at `x` and `y`.
      def rgb_at(x : UInt32, y : UInt32, cyan : UInt8, magenta : UInt8, yellow : UInt8, black : UInt8)
        @buf[y*@width*4+x*4] = cyan
        @buf[y*@width*4+x*4+1] = magenta
        @buf[y*@width*4+x*4+2] = yellow
        @buf[y*@width*4+x*4+3] = black
      end

      def []=(x : Number, y : Number, color : CmykColor)
        rgb_at(x.to_u32, y.to_u32, color.cyan, color.magenta, color.yellow, color.black)
      end
    end
  end
end
