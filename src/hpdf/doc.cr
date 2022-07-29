require "./helper"

module Hpdf
  class Doc
    include Helper

    @doc : LibHaru::Doc
    @pages : Array(Page)

    def initialize
      @doc = LibHaru.new(->(error_no, detail_no, asd) {
        raise Exception.errcode(error_no, detail_no)
      }, nil)
      unless @doc
        raise Exception.new("error: cannot create PdfDoc object")
      end
      @pages = Array(Page).new
    end

    def to_unsafe
      @doc
    end

    # will free any related memory in case the document
    # is not used any longer
    def finalize
      LibHaru.free(self)
    end

    # saves the current document to a file.
    def save_to_file(path : String)
      LibHaru.save_to_file(self, path)
    end

    # writes the document to an in memory IO object
    # this will require memory for the size of the document.
    def to_io : IO
      stream = IO::Memory.new
      slice = Bytes.new(4096)

      LibHaru.save_to_stream(self)


      while true
        size = slice.size.to_u32
        LibHaru.read_from_stream(self, slice, pointerof(size))
        break if size == 0
        stream.write(slice[0...size])
      end

      LibHaru.reset_stream(self)

      stream.rewind
      return stream
    end

    # In the default setting, a `Doc` object has one "Pages" object as root
    # of pages. All "Page" objects are created as a kid of the "Pages" object.
    # Since a "Pages" object can own only 8191 kids objects, the maximum number
    # of pages are 8191 page.
    #
    # ![http://libharu.sourceforge.net/image/figure7.png](http://libharu.sourceforge.net/image/figure7.png)
    #
    # Additionally, the state that there are a lot of  "Page" object under one
    # "Pages" object is not good, because it causes performance degradation of
    # a viewer application.
    #
    # An application can change the setting of a pages tree by invoking
    # `pages_configuration=` . If *page_per_pages* parameter is set to more than
    #  zero, a two-tier pages tree is created. A root "Pages" object can own
    # 8191 "Pages" object, and each lower "Pages" object can own
    # *page_per_pages* "Page" objects. As a result, the maximum number of pages
    # becomes 8191 * *page_per_pages* page.
    #
    # ![http://libharu.sourceforge.net/image/figure8.png](http://libharu.sourceforge.net/image/figure8.png)
    #
    # An application cannot invoke `pages_configuration=` after a page is added
    # to document.
    def pages_configuration=(page_per_pages : Number)
      LibHaru.set_pages_configuration(self, page_per_pages)
    end

    # sets how the page should be displayed. If this attribute is not set, the
    # setting of the viewer application is used.
    def page_layout=(layout : PageLayout)
      LibHaru.set_page_layout(self, layout)
    end

    # the current setting for page layout.
    def page_layout : PageLayout
      PageLayout.new LibHaru.get_page_layout(self).to_i32
    end

    # sets how the document should be displayed.
    def page_mode=(mode : PageMode)
      LibHaru.set_page_mode(self, mode)
    end

    # the current setting for page mode.
    def page_mode : PageMode
      PageMode.new LibHaru.get_page_mode(self).to_i32
    end

    # the handle of current page object.
    def current_page : Page?
      return nil if @pages.empty?
      cp = LibHaru.get_current_page(self)
      @pages.find do |page|
        page.to_unsafe == cp
      end
    end

    # creates a new page and adds it after the last page of a document.
    def add_page : Page
      page = Page.new(LibHaru.add_page(self), self)
      @pages << page
      page
    end

    # creates a new page and inserts it just before the specified `page`.
    def insert_page(page : Page) : Page
      idx = @pages.index!(page)
      new_page = Page.new(LibHaru.insert_page(self, page), self)
      @pages.insert index: idx, object: new_page
      new_page
    end

    # gets the handle of a corresponding font object by specified name and encoding.
    def font(name : String, encoding : String? = nil)
      Font.new(LibHaru.get_font(@doc, name, encoding), self)
    end

    # loads a type1 font from an external file and register it to a document object.
    # Returns the name of a font.
    #
    # * *afm_file* path of an AFM file.
    # * *data_file* path of a PFA/PFB file. If it is `nil`, the gryph data of font file is not embedded to a PDF file.
    def load_type1_font_from_file(afm_file : String, data_file : String? = nil) : String
      String.new(LibHaru.load_type1_font_from_file(self, afm_file, data_file))
    end

    # loads a TrueType font from an external file and register it to a document object.
    # Returns the name of a font.
    #
    # * *file_name* path of a TrueType font file (.ttf).
    # * *embedding* this parameter is set to `true`, the glyph data of the font is embedded, otherwise only the matrix data is included in PDF file.
    def load_tt_font_from_file(file_name : String, embedding : Bool = true)
      String.new(LibHaru.load_tt_font_from_file(self, file_name, bool(embedding)))
    end

    # loads a TrueType font from an TrueType collection file and register it to a document object.
    # Returns the name of a font.
    #
    # * *file_name* path of a TrueType font collection file (.ttc).
    # * *index* index of font that wants to be loaded.
    # * *embedding* this parameter is set to `true`, the glyph data of the font is embedded, otherwise only the matrix data is included in PDF file.
    def load_tt_font_from_collection_file(file_name : String, index : Number, embedding : Bool = true) : String
      String.new(LibHaru.load_tt_font_from_file2(self, file_name, uint(index), bool(embedding)))
    end

    # adds a page labeling range for the document.
    #
    # * *page_num* the first page that applies this labeling range.
    # * *style* the numbering style.
    # * *first_page* the first page number in this range.
    # * *prefix* the prefix for the page label.
    def add_page_label(page_num : Number, style : PageNumStyle, *, first_page = 1, prefix : String? = nil)
      LibHaru.add_page_label(self, page_num, style, first_page, prefix)
    end

    # enables Japanese fonts. After `use_jp_fonts` is called, an application
    # can use the following Japanese fonts: `JapaneseFonts::All`
    def use_jp_fonts
      LibHaru.use_jp_fonts(self)
    end

    # enables Japanese fonts. After `use_kr_fonts` is called, an application
    # can use the following Korean fonts: `KoreanFonts::All`
    def use_kr_fonts
      LibHaru.use_kr_fonts(self)
    end

    # enables Japanese fonts. After `use_cns_fonts` is called, an application
    # can use the following simplified Chinese fonts: `ChineseSimplifiedFonts::All`
    def use_cns_fonts
      LibHaru.use_cns_fonts(self)
    end

    # enables Japanese fonts. After `use_jp_fonts` is called, an application
    # can use the following traditional Chinese fonts: `ChineseTraditionalFonts::All`
    def use_cnt_fonts
      LibHaru.use_cnt_fonts(self)
    end

    # TODO fun create_outline
    # TODO fun encoder
    # TODO fun current_encoder
    # TODO fun current_encoder=
    # TODO use_jp_encodings
    # TODO use_kr_encodings
    # TODO use_cns_encodings
    # TODO use_cnt_encodings

    # loads an external png image file.
    #
    # * *file_name* path to a PNG image file.
    # * *lazy* if `true` does not load whole data immediately (only size and color properties
    #   is loaded). The main data is loaded just before the image object is written
    #   to PDF, and the loaded data is deleted immediately.
    def load_png_image_from_file(file_name : String, *, lazy : Bool = false) : Image
      if lazy
        Image.new(LibHaru.load_png_image_from_file2(self, file_name), self)
      else
        Image.new(LibHaru.load_png_image_from_file(self, file_name), self)
      end
    end

    # loads an image which has "raw" image format.
    # This function loads the data without any conversion.
    # So it is usually faster than the other functions.
    #
    # `load_raw_image_from_file` can load 3 types of format described below.
    #
    # * *file_name* path to a RAW image file.
    # * *width* the width of the image file.
    # * *height* the height of the image file.
    # * *color_space* `ColorSpace::DeviceGray` or `ColorSpace::DeviceRgb`
    #   or `ColorSpace::DeviceCmyk` is allowed.
    #
    # ### `ColorSpace::DeviceGray`
    #
    # The gray scale describes one pixel by one byte. And the size of the
    # image data is same as `width * height`.
    # The sequence of the data is as follows.
    #
    # <table style="width: 100px; text-align: left;" cellspacing="1" cellpadding="1" border="1">
    #   <tbody>
    #   <tr>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">1<br>
    #     </td>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">2<br>
    #     </td>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">3<br>
    #     </td>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">4<br>
    #     </td>
    #   </tr>
    #   <tr>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">6<br>
    #     </td>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">7<br>
    #     </td>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">8<br>
    #     </td>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">9<br>
    #     </td>
    #   </tr>
    #   <tr>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">11<br>
    #     </td>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">12<br>
    #     </td>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">13<br>
    #     </td>
    #     <td style="vertical-align: top; background-color: rgb(204, 204, 204); text-align: center;">14<br>
    #     </td>
    #   </tr>
    # </tbody>
    # </table>
    #
    # ### `ColorSpace::DeviceRgb`
    #
    # The 24bit RGB color image describes one pixel by 3 byte (each one byte
    # describes a value of either red, green or blue). And the size of the
    # image is same as `width * height * 3`.
    # The sequence of the data is as follows.
    #
    # <table style="width: 100px; text-align: left;" cellspacing="1" cellpadding="1" border="1">
    #   <tbody>
    #     <tr>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">1<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">1<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(204, 255, 255); text-align: center;">1<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">2<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">2<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(204, 255, 255); text-align: center;">2<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">3<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">3<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(204, 255, 255); text-align: center;">3<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">4<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">4<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">4<br>
    #       </td>
    #     </tr>
    #     <tr>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">6<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">6<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(204, 255, 255); text-align: center;">6<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">7<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">7<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(204, 255, 255); text-align: center;">7<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">8<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">8<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(204, 255, 255); text-align: center;">8<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">9<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">9<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">9<br>
    #       </td>
    #     </tr>
    #     <tr>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">11<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">11<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(204, 255, 255); text-align: center;">11<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">12<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">12<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(204, 255, 255); text-align: center;">12<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">13<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">13<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(204, 255, 255); text-align: center;">13<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(255, 204, 204); text-align: center;">14<br>
    #       </td>
    #       <td style="vertical-align: top; background-color: rgb(153, 255, 153); text-align: center;">14<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">14<br>
    #       </td>
    #     </tr>
    #   </tbody>
    # </table>
    #
    # ### `ColorSpace::DeviceCmyk`
    #
    # The 36bit CMYK color image describes one pixel by 4 byte (each one
    # byte describes a value of either Cyan Magenta Yellow Black).
    # And the size of the image is same as `width * height * 4`.
    # The sequence of the data is as follows.
    #
    # <table style="width: 100px; text-align: left;" cellspacing="1" cellpadding="1" border="1">
    #   <tbody>
    #     <tr>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">1<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">1<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">1<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">1<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">2<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">2<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">2<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">2<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">3<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">3<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">3<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">3<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">4<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">4<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">4<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">4<br>
    #       </td>
    #     </tr>
    #     <tr>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">6<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">6<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">6<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">6<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">7<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">7<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">7<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">7<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">8<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">8<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">8<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">8<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">9<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">9<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">9<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">9<br>
    #       </td>
    #     </tr>
    #     <tr>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">11<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">11<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">11<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">11<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">12<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">12<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">12<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">12<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">13<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">13<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">13<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">13<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 255, 255);">14<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 204, 255);">14<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(255, 255, 153);">14<br>
    #       </td>
    #       <td style="vertical-align: top; text-align: center; background-color: rgb(204, 204, 204);">14<br>
    #       </td>
    #     </tr>
    #   </tbody>
    # </table>
    def load_raw_image_from_file(file_name : String, width : Number,
                                 height : Number, color_space : ColorSpace) : Image
      Image.new(LibHaru.load_raw_image_from_file(self, filename, uint(width), uint(height), color_space), self)
    end

    # loads an image which has "raw" image format from buffer.
    # This function loads the data without any conversion. So it is
    # usually faster than the other functions.
    #
    # The formats that `load_raw_image_from_mem` can load is the same as `load_raw_image_from_file`.
    #
    # * *buf* buffer with a raw memory image, has to implement `#unsafe`.
    # * *width* the width of the image.
    # * *height* the height of the image.
    # * *color_space* `ColorSpace::DeviceGray` or `ColorSpace::DeviceRgb`
    #   or `ColorSpace::DeviceCmyk` is allowed.
    # * *bits_per_component* The bit size of each color component. The valid value is either 1, 2, 4, 8.
    def load_raw_image_from_mem(buf, width : Number, height : Number,
                                color_space : ColorSpace = ColorSpace::DeviceRgb,
                                bits_per_component : UInt8 = 8)
      Image.new(LibHaru.load_raw_image_from_mem(self, buf, uint(width), uint(height), color_space, uint(bits_per_component)), self)
    end

    # loads an image which has "raw" image format from buffer.
    # This function loads the data without any conversion. So it is
    # usually faster than the other functions.
    def load_raw_image_from_mem(img : InMemoryImage)
      load_raw_image_from_mem(img, img.width, img.height, img.color_space, 8)
    end

    # loads an external Jpeg image file.
    #
    # * *file_name* path to a jpeg image file.
    def load_jpeg_image_from_file(file_name : String)
      Image.new(LibHaru.load_jpeg_image_from_file(self, file_name), self)
    end

    def creation_date : Time?
      v = LibHaru.get_info_attr(self, InfoType::CreationDate)
      Date.parse(String.new(v)) unless v.null?
    end

    def creation_date=(time : Time)
      LibHaru.set_info_date_attr(self, InfoType::CreationDate, Date.new(time))
    end

    def mod_date : Time?
      v = LibHaru.get_info_attr(self, InfoType::ModDate)
      Date.parse(String.new(v)) unless v.null?
    end

    def mod_date=(time : Time)
      LibHaru.set_info_date_attr(self, InfoType::ModDate, Date.new(time))
    end

    def author : String?
      nilable_str LibHaru.get_info_attr(self, InfoType::Author)
    end

    def author=(v : String)
      LibHaru.set_info_attr(self, InfoType::Author, v)
    end

    def creator : String?
      nilable_str LibHaru.get_info_attr(self, InfoType::Producer)
    end

    def creator=(v : String)
      LibHaru.set_info_attr(self, InfoType::Producer, v)
    end

    def title : String?
      nilable_str LibHaru.get_info_attr(self, InfoType::Title)
    end

    def title=(v : String)
      LibHaru.set_info_attr(self, InfoType::Title, v)
    end

    def subject : String?
      nilable_str LibHaru.get_info_attr(self, InfoType::Subject)
    end

    def subject=(v : String)
      LibHaru.set_info_attr(self, InfoType::Subject, v)
    end

    def keywords : String?
      nilable_str LibHaru.get_info_attr(self, InfoType::Keywords)
    end

    def keywords=(v : String)
      LibHaru.set_info_attr(self, InfoType::Keywords, v)
    end

    # sets the pasword for the document.
    # If the password is set, contents in the document are encrypted.
    #
    # * *owner_password* the password for the owner of the document.
    #   The owner can change the permission of the document.
    #   `nil`, zero length string and the same value as user password
    #   are not allowed.
    # * *user_password* the password for the user of the document.
    # The user_password is allowed to be set to `nil` or zero length string.
    # * *permission* the flags specifying which operations are permitted.
    #   This parameter is set by logical addition of the following values.
    def set_password_and_permission(owner_password : String, *,
        user_password : String? = nil,
        permission : Permission = Permission::EnableRead,
        encryption_mode : EncryptMode = EncryptMode::EncryptR3,
        encryption_key_len_bytes : Int32 = 16)
        LibHaru.set_password(self, owner_password, user_password)
        LibHaru.set_permission(self, permission)
        LibHaru.set_encryption_mode(self, encryption_mode, uint(encryption_key_len_bytes))
    end

    # set the mode of compression.
    def compression_mode=(mode : CompressionMode)
      LibHaru.set_compression_mode(self, mode)
    end
  end
end
