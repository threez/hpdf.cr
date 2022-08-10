describe Hpdf::Letter do
  it "creates letters with ease" do
    testdoc "letter-5008-a" do
      page Hpdf::LetterDIN5008A do
        draw

        draw_address company: "Evil Corp",
          salutation: "Mr.",
          name: "Robot",
          street: "Street 1",
          place: "New York",
          country: "USA"

        draw_return_address "Good Corp | Awesomestr. 20 | 12345 Place"

        # 3. ZVZ – z. B. elektronische Freimachungsvermerke
        # 2. ZVZ – z. B. Vorausverfügung Nicht nachsenden!
        # 1. ZVZ – z. B. Einschreiben / Recommandé
        # 1. AZ – Firma (= Name des Unternehmens)
        # 2. AZ – Anrede, ggf. Berufs- oder Amtsbezeichnungen
        # 3. AZ – ggf. akademische Grade (z. B. Dr., Dipl.-Ing., Dipl.-Hdl.), Name
        # 4. AZ – Straße/Hausnummer (ggf. // App.-Nr.) oder Postfach
        # 5. AZ – Postleitzahl und Bestimmungsort
        # 6. AZ – (LAND)
      end
    end
  end
end
