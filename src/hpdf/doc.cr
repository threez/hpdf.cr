module Hpdf
  class Doc
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

    def add_page : Page
      page = Page.new(LibHaru.add_page(self), self)
      @pages << page
      page
    end

    def font(name, encoding = nil)
      Font.new(self, name, encoding)
    end
  end
end
