describe Hpdf::Doc do
  describe "#pdfa_conformance=" do
    it "accepts PDF/A-1B conformance" do
      testdoc "pdfa-1b" do |pdf|
        pdf.pdfa_conformance = Hpdf::PDFAConformance::PDFA_1B
        page = pdf.add_page
        page.text Hpdf::Base14::Helvetica, 12 do
          page.text_out 50, 700, "PDF/A-1B"
        end
      end
    end

    it "accepts PDF/A-3B conformance" do
      testdoc "pdfa-3b" do |pdf|
        pdf.pdfa_conformance = Hpdf::PDFAConformance::PDFA_3B
        page = pdf.add_page
        page.text Hpdf::Base14::Helvetica, 12 do
          page.text_out 50, 700, "PDF/A-3B"
        end
      end
    end

    it "produces a valid PDF stream" do
      testdoc do |pdf|
        pdf.pdfa_conformance = Hpdf::PDFAConformance::PDFA_3B
        pdf.add_page
        stream = pdf.to_io
        stream.to_s[0..6].should eq "%PDF-1."
      end
    end
  end

  describe "#add_xmp_extension" do
    it "injects an XMP extension without raising" do
      testdoc do |pdf|
        pdf.pdfa_conformance = Hpdf::PDFAConformance::PDFA_3B
        xml = <<-XML
          <rdf:Description xmlns:zf="urn:ferd:pdfa:CrossIndustryDocument:invoice:1p0#">
            <zf:ConformanceLevel>EN 16931</zf:ConformanceLevel>
          </rdf:Description>
          XML
        pdf.add_xmp_extension xml
        pdf.add_page
      end
    end
  end

  describe "#attach_file" do
    it "attaches a file with default metadata" do
      testdoc "pdfa-attachment" do |pdf|
        pdf.pdfa_conformance = Hpdf::PDFAConformance::PDFA_3B
        result = pdf.attach_file "spec/data/attachment.xml"
        result.should eq pdf
        pdf.add_page
      end
    end

    it "accepts a custom name and description" do
      testdoc do |pdf|
        pdf.pdfa_conformance = Hpdf::PDFAConformance::PDFA_3B
        pdf.attach_file "spec/data/attachment.xml",
          name: "invoice.xml",
          description: "Invoice data"
        pdf.add_page
      end
    end

    it "accepts a custom MIME subtype" do
      testdoc do |pdf|
        pdf.pdfa_conformance = Hpdf::PDFAConformance::PDFA_3B
        pdf.attach_file "spec/data/attachment.xml", subtype: "application/xml"
        pdf.add_page
      end
    end

    it "accepts all AFRelationship values" do
      Hpdf::AFRelationship.values.each do |rel|
        testdoc do |pdf|
          pdf.pdfa_conformance = Hpdf::PDFAConformance::PDFA_3B
          pdf.attach_file "spec/data/attachment.xml", relationship: rel
          pdf.add_page
        end
      end
    end

    it "accepts creation and modification dates" do
      testdoc do |pdf|
        pdf.pdfa_conformance = Hpdf::PDFAConformance::PDFA_3B
        t = Time.utc(2024, 1, 15, 10, 0, 0)
        pdf.attach_file "spec/data/attachment.xml",
          creation_date: t,
          modification_date: t
        pdf.add_page
      end
    end

    it "returns self for chaining" do
      testdoc do |pdf|
        pdf.pdfa_conformance = Hpdf::PDFAConformance::PDFA_3B
        pdf
          .attach_file("spec/data/attachment.xml", name: "a.xml")
          .attach_file("spec/data/attachment.xml", name: "b.xml")
        pdf.add_page
      end
    end
  end
end
