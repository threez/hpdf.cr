require "spec"
require "../src/hpdf"

module Suite
  DOC = Hpdf::Doc.new
end

def create_font
  Suite::DOC.font "Helvetica"
end

def testdoc(filename : String? = nil, &)
  LibHaru.new_doc(Suite::DOC)
  with Suite::DOC yield Suite::DOC
  unless filename.nil?
    filename = filename.downcase.gsub /[^a-z0-9]+/, "-"
    path = "pdfs/spec-#{filename}.pdf"
    Suite::DOC.save_to_file path
  end
  Suite::DOC
end

def testpage(filename : String? = nil, &)
  testdoc filename do |pdf|
    page do |page|
      with page yield page, pdf
    end
  end
end
