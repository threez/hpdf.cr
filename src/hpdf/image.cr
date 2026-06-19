module Hpdf
  # The image is used to display image to a page mainly. To create/load
  # an image use:
  #
  # * **PNG** `Doc#load_png_image_from_file` or `Doc#load_png_image`
  # * **JPEG** `Doc#load_jpeg_image_from_file` or `Doc#load_jpeg_image`
  # * **RAW** `Doc#load_raw_image_from_file`, `Doc#load_raw_image_from_mem`, or `Doc#load_raw1_bit_image`
  class Image
    include Helper

    def initialize(@image : LibHaru::Image, @doc : Doc)
    end

    def to_unsafe
      @image
    end

    # gets the size of the image of an image object.
    def size : Size
      s = LibHaru.image_get_size(self)
      Size.new(width: s.x.to_u32, height: s.y.to_u32)
    end

    # gets the size of the image via an out-parameter variant of `#size`.
    # Both methods return the same value; this one exists for completeness.
    def size2 : Size
      pt = LibHaru::Point.new
      LibHaru.image_get_size2(self, pointerof(pt))
      Size.new(width: pt.x.to_u32, height: pt.y.to_u32)
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
    def set_color_mask(*,
                       rmin : UInt8 = 0, rmax : UInt8 = 0,
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

    # attaches a soft-mask image to this image for per-pixel opacity control.
    # The soft mask must be a grayscale image: white = fully opaque, black = fully transparent.
    #
    # * *smask* the grayscale `Image` to use as a soft mask.
    def smask=(smask : Image)
      LibHaru.image_add_smask(self, smask)
    end
  end
end
