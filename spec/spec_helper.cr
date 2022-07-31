require "spec"
require "../src/hpdf"

def create_font
  pdf = Hpdf::Doc.new
  pdf.font "Helvetica"
end

def testdoc(&block)
  pdf = Hpdf::Doc.new
  with pdf yield pdf
end

def testpage(&block)
  pdf = Hpdf::Doc.new
  page = pdf.add_page
  with page yield page
end
