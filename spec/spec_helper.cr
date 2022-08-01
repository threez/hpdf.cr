require "spec"
require "../src/hpdf"

def create_font
  pdf = Hpdf::Doc.new
  pdf.font "Helvetica"
end

def testdoc(filename : String? = nil, &block)
  pdf = Hpdf::Doc.new
  with pdf yield pdf
  pdf.save_to_file "spec-#{filename}.pdf" unless filename.nil?
  pdf
end

def testpage(filename : String? = nil, &block)
  testdoc filename do |pdf|
    page do |page|
      with page yield page, pdf
    end
  end
end
