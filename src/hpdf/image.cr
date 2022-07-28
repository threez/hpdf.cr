module Hpdf
  # The image is used to display image to a page mainly. To create/load
  # an image use:
  #
  # * **PNG** `Doc#load_png_image_from_file`
  # * **RAW** `Doc#load_raw_image_from_file` or `Doc#load_raw_image_from_mem`
  class Image
    include Helper

    struct Size
      property width, height

      def initialize(@width : UInt32, @height : UInt32)
      end
    end

    def initialize(@image : LibHaru::Image, @doc : Doc)
    end

    def to_unsafe
      @image
    end

    # gets the size of the image of an image object.
    def get_size : Size
      s = LibHaru.image_get_size(self)
      Size.new(width:s.x.to_u32, height:s.y.to_u32)
    end

    # gets the width of the image of an image object.
    def width : Number
      LibHaru.image_get_width(self).to_i
    end

    # gets the height of the image of an image object.
    def height : Number
      LibHaru.image_get_height(self).to_i
    end

    # gets the number of bits used to describe each color component.
    def bits_per_component : Number
      LibHaru.image_get_bits_per_component(self).to_i
    end

    # gets the name of the image's color space.
    # Usually one of `"DeviceGray"`, `"DeviceRGB"`, `"DeviceCMYK"` or
    # `"Indexed"`.
    def color_space : String
      String.new(LibHaru.image_get_color_space(self))
    end

    # sets the transparent color of the image by the RGB range values.
    # The color within the range is displayed as a transparent color.
    # The Image must be RGB color space.
    #
    # * *rmin* lower limit of Red. It must be between `0` and `255`.
    # * *rmax* upper limit of Red. It must be between `0` and `255`.
    # * *gmin* lower limit of Green. It must be between `0` and `255`.
    # * *gmax* upper limit of Green. It must be between `0` and `255`.
    # * *bmin* lower limit of Blue. It must be between `0` and `255`.
    # * *bmax* upper limit of Blue. It must be between `0` and `255`.
    def set_color_mask(*, rmin : UInt8 = 0, rmax : UInt8 = 0,
                          gmin : UInt8 = 0, gmax : UInt8 = 0,
                          bmin : UInt8 = 0, bmax : UInt8 = 0)
      LibHaru.image_set_color_mask(self, uint(rmin), uint(rmax), uint(gmin),
                                         uint(gmax), uint(bmin), uint(bmax))
    end

    # sets the mask image.
    #
    # * *mask* image object which is used as image-mask.
    #   This image must be 1bit gray-scale color image.
    def mask_image=(mask : Image)
      LibHaru.image_set_mask_image(self, mask)
    end
  end

  abstract class InMemoryImage
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
        raise Exception.new("invalid color_space was used: #{@color_space}")
      end
    end

    def to_unsafe
      @buf.to_unsafe
    end
  end

  # create a new in-momory image with gray scale
  class InMemoryGrayImage < InMemoryImage
    def initialize(width : UInt32, height : UInt32)
      super width, height, ColorSpace::DeviceGray
    end

    # sets the gray value at `x` and `y` via `scale`.
    # `0xff` is white and `0x00` is black.
    def gray_at(x : Int32, y : Int32, scale : UInt8)
      @buf[y*@width+x] = scale
    end
  end
end
