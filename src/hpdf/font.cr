require "./helper"

module Hpdf
  class Font
    include Helper

    def initialize(@font : LibHaru::Font, @doc : Doc)
    end

    def to_unsafe
      @font
    end

    # the name of the font.
    def name : String
      String.new(LibHaru.font_get_font_name(self))
    end

    # the encoding name of the font.
    def encoding_name : String
      String.new(LibHaru.font_get_encoding_name(self))
    end

    # the width of a charactor in the font.
    def unicode_width(char : UInt16) : Int32
      LibHaru.font_get_unicode_width(self, char)
    end

    # the bounding box of the font.
    def b_box : Rectangle
      Rectangle.new(LibHaru.font_get_b_box(self))
    end

    # the vertical ascent of the font in UPM (units per eM).
    def ascent : Int32
      LibHaru.font_get_ascent(self)
    end

    # the vertical descent of the font in UPM (units per eM).
    def descent : Int32
      LibHaru.font_get_descent(self)
    end

    # the distance from the baseline of lowercase letters in UPM (units per eM).
    def x_height : UInt32
      LibHaru.font_get_x_height(self)
    end

    # the distance from the baseline of uppercase letters in UPM (units per eM).
    def cap_height : UInt32
      LibHaru.font_get_cap_height(self)
    end

    # the vertical ascent of the font in points calculated
    # based on the given *font_size*.
    #
    # * *font_size* the size to calculate the height with.
    def ascent(font_size : Number) : Float32
      (ascent * font_size / 1000).to_f32
    end

    # the vertical descent of the font in points calculated
    # based on the given *font_size*.
    #
    # * *font_size* the size to calculate the height with.
    def descent(font_size : Number) : Float32
      (descent * font_size / 1000).to_f32
    end

    # the distance from the baseline of lowercase letters in points calculated
    # based on the given *font_size*.
    #
    # * *font_size* the size to calculate the height with.
    def x_height(font_size : Number) : Float32
      (x_height * font_size / 1000).to_f32
    end

    # the distance from the baseline of uppercase letters in points calculated
    # based on the given *font_size*.
    #
    # * *font_size* the size to calculate the height with.
    def cap_height(font_size : Number) : Float32
      (cap_height * font_size / 1000).to_f32
    end

    # total width of the text, number of charactors and number of the words.
    def text_width(text : String)
      LibHaru.font_text_width(self, text, text.size)
    end

    # calculates the byte length which can be included within the specified width.
    #
    # * *width* The width of the area to put the text.
    # * *font_size* The size of the font.
    # * *char_space* The character spacing.
    # * *word_space* The word spacing.
    # * *word_wrap* When there are three words of `"ABCDE FGH IJKL"`, and the substring
    #   until `"J"` can be included within the width, if *word_wrap* parameter is `false`
    #   it returns `12`,  and if word_wrap parameter is `false` *word_wrap* parameter is
    #   `false` it returns `10` (the end of the previous word).
    def measure_text(text : String, *, width : Number, font_size : Number, char_space : Number, word_space : Number, word_wrap : Bool = true) : MeasuredText
      size = LibHaru.font_measure_text(self, text, text.size,
        real(width), real(font_size), real(char_space), real(word_space),
        bool(word_wrap), out real_width)
      MeasuredText.new(size, real_width)
    end
  end
end
