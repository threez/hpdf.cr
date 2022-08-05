require "./helper"

module Hpdf
  module Encodings
    StandardEncoding = "StandardEncoding"
    MacRomanEncoding = "MacRomanEncoding"
    WinAnsiEncoding = "WinAnsiEncoding"
    ISO8859_2 = "ISO8859-2"
    ISO8859_3 = "ISO8859-3"
    ISO8859_4 = "ISO8859-4"
    ISO8859_5 = "ISO8859-5"
    ISO8859_9 = "ISO8859-9"
    ISO8859_10 = "ISO8859-10"
    ISO8859_13 = "ISO8859-13"
    ISO8859_14 = "ISO8859-14"
    ISO8859_15 = "ISO8859-15"
    ISO8859_16 = "ISO8859-16"
    CP1250 = "CP1250"
    CP1251 = "CP1251"
    CP1252 = "CP1252"
    CP1254 = "CP1254"
    CP1257 = "CP1257"
    KOI8_R = "KOI8-R"
    SymbolSet = "Symbol-Set"
    ZapfDingbatsSet = "ZapfDingbats-Set"

    {% begin %}
    All = [
      {% for constant in @type.constants %}
        {{constant}},
      {% end %}
    ]
    {% end %}
  end

  class Encoder
    include Helper

    def initialize(@encoder : LibHaru::Encoder, @doc : Doc)
    end

    def to_unsafe
      @encoder
    end

    # gets the type of an encoding object.
    def type : EncoderType
      EncoderType.new(LibHaru.encoder_get_type(self))
    end

    # returns the type of byte in the text at position index.
    def byte_type(text : String, idx : Number) : ByteType
      ByteType.new(LibHaru.encoder_get_type(self, text, uint(idx)))
    end

    # converts a specified character code to unicode.
    def unicode(code : UInt16) : Char
      LibHaru.encoder_get_unicode(self, code).unsafe_chr
    end

    # returns the writing mode for the encoding object.
    def writing_mode
      WritingMode.new(LibHaru.encoder_get_writing_mode(self))
    end
  end
end
