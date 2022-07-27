require "spec"
require "../src/hpdf"

def create_font
  pdf = Hpdf::Doc.new
  pdf.font "Helvetica"
end
