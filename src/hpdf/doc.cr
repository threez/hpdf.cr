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
  end
end
