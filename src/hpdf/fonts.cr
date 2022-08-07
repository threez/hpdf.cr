module Hpdf
  module FontLibrary
    macro included
      {% begin %}
      All = [
        {% for constant in @type.constants %}
          {{constant}},
        {% end %}
      ]
      {% end %}
    end
  end

  # `Base14` fonts are built-in font of PDF, and all the Viewer
  # applications can display these fonts. An application can get
  # a font-handle of a base14 font any time by invoking `Doc#font`.
  # The size of pdf files which use base14 fonts become smaller
  # than those which use other type of fonts. Moreover, a processing
  # that creates the PDF file is fast because of that there is no
  # overhead that loads the font.
  # However, base14 fonts are only available to display latin1
  # character set. To use other character set, an application have
  # to use other type of font.
  module Base14
    Courier              = "Courier"
    CourierBold          = "Courier-Bold"
    CourierOblique       = "Courier-Oblique"
    CourierBoldOblique   = "Courier-BoldOblique"
    Helvetica            = "Helvetica"
    HelveticaBold        = "Helvetica-Bold"
    HelveticaOblique     = "Helvetica-Oblique"
    HelveticaBoldOblique = "Helvetica-BoldOblique"
    TimesRoman           = "Times-Roman"
    TimesBold            = "Times-Bold"
    TimesItalic          = "Times-Italic"
    TimesBoldItalic      = "Times-BoldItalic"
    Symbol               = "Symbol"
    ZapfDingbats         = "ZapfDingbats"

    include FontLibrary
  end

  # enabled using `Doc#use_jp_fonts`
  module JapaneseFonts
    MsMincyo            = "MS-Mincyo"
    MsMincyoBold        = "MS-Mincyo,Bold"
    MsMincyoItalic      = "MS-Mincyo,Italic"
    MsMincyoBoldItalic  = "MS-Mincyo,BoldItalic"
    MsGothic            = "MS-Gothic"
    MsGothicBold        = "MS-Gothic,Bold"
    MsGothicItalic      = "MS-Gothic,Italic"
    MsGothicBoldItalic  = "MS-Gothic,BoldItalic"
    MsPMincyo           = "MS-PMincyo"
    MsPMincyoBold       = "MS-PMincyo,Bold"
    MsPMincyoItalic     = "MS-PMincyo,Italic"
    MsPMincyoBoldItalic = "MS-PMincyo,BoldItalic"
    MsPGothic           = "MS-PGothic"
    MsPGothicBold       = "MS-PGothic,Bold"
    MsPGothicItalic     = "MS-PGothic,Italic"
    MsPGothicBoldItalic = "MS-PGothic,BoldItalic"

    include FontLibrary
  end

  # enabled using `Doc#use_kr_fonts`
  module KoreanFonts
    DotumChe            = "DotumChe"
    DotumCheBold        = "DotumChe,Bold"
    DotumCheItalic      = "DotumChe,Italic"
    DotumCheBoldItalic  = "DotumChe,BoldItalic"
    Dotum               = "Dotum"
    DotumBold           = "Dotum,Bold"
    DotumItalic         = "Dotum,Italic"
    DotumBoldItalic     = "Dotum,BoldItalic"
    BatangChe           = "BatangChe"
    BatangCheBold       = "BatangChe,Bold"
    BatangCheItalic     = "BatangChe,Italic"
    BatangCheBoldItalic = "BatangChe,BoldItalic"
    Batang              = "Batang"
    BatangBold          = "Batang,Bold"
    BatangItalic        = "Batang,Italic"
    BatangBoldItalic    = "Batang,BoldItalic"

    include FontLibrary
  end

  # enabled using `Doc#use_cns_fonts`
  module ChineseSimplifiedFonts
    SimSun           = "SimSun"
    SimSunBold       = "SimSun,Bold"
    SimSunItalic     = "SimSun,Italic"
    SimSunBoldItalic = "SimSun,BoldItalic"
    SimHei           = "SimHei"
    SimHeiBold       = "SimHei,Bold"
    SimHeiItalic     = "SimHei,Italic"
    SimHeiBoldItalic = "SimHei,BoldItalic"

    include FontLibrary
  end

  # enabled using `Doc#use_cnt_fonts`
  module ChineseTraditionalFonts
    MingLiU           = "MingLiU"
    MingLiUBold       = "MingLiU,Bold"
    MingLiUItalic     = "MingLiU,Italic"
    MingLiUBoldItalic = "MingLiU,BoldItalic"

    include FontLibrary
  end
end
