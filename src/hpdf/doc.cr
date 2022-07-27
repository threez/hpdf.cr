module Hpdf
  class Doc
    @doc : LibHaru::Doc

    def initialize
      @doc = LibHaru.new(->(error_no, detail_no, asd) {
        raise Exception.errcode(error_no, detail_no)
      }, nil)
      unless @doc
        raise Exception.new("error: cannot create PdfDoc object")
      end
    end

    def to_unsafe
      @doc
    end

    def save_to_file(path)
      LibHaru.save_to_file(self, path)
    end

    def finalize
      LibHaru.free(self)
    end

    def add_page
      Page.new(self)
    end

    def font(name, encoding = nil)
      Font.new(self, name, encoding)
    end
  end
end
