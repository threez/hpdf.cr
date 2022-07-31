module Hpdf
  enum InfoType
    # date-time type parameters
    CreationDate = 0
    ModDate

    # string type parameters
    Author
    Creator
    Producer
    Title
    Subject
    Keywords
    Trapped
    GtsPdfx
  end

  enum ColorSpace
    DeviceGray = 0
    DeviceRgb
    DeviceCmyk
    CalGray
    CalRgb
    Lab
    IccBased
    Separation
    DeviceN
    Indexed
    Pattern
  end

  # used in `Doc#page_layout=`.
  enum PageLayout
    # Only one page is displayed.
    Single = 0
    # Display the pages in one column.
    OneColumn
    # Display the pages in two column. The page of the odd number is displayed left.
    TwoColumnLeft
    # Display the pages in two column. The page of the odd number is displayed right.
    TwoColumnRight
    # TwoPageLeft
    # TwoPageRight
    Default = 6
  end

  # used in `Doc#page_mode=`.
  enum PageMode
    # Display the document with neither outline nor thumbnail.
    UseNone = 0
    # Display the document with outline pain.
    UseOutline
    # Display the document with thumbnail pain.
    UseThumbs
    # Display the document with full screen mode.
    FullScreen
    # UseOc
    # UseAttachments
  end

  # used in `Doc#add_page_label`.
  enum PageNumStyle
    # Page label is displayed by Arabic numerals.
    Decimal = 0
    # Page label is displayed by Uppercase roman numerals.
    UpperRoman
    # Page label is displayed by Lowercase roman numerals.
    LowerRoman
    # Page label is displayed by Uppercase letters (using A to Z).
    UpperLetters
    # Page label is displayed by Lowercase letters (using a to z).
    LowerLetters
  end

  # used in `Page#line_cap=`.
  enum LineCap
    # The line is squared off at the endpoint of the path.
    #
    # ![http://libharu.sourceforge.net/image/figure10.png](http://libharu.sourceforge.net/image/figure10.png)
    ButtEnd = 0
    # The end of a line becomes a semicircle whose center is the end point of the path.
    #
    # ![http://libharu.sourceforge.net/image/figure11.png](http://libharu.sourceforge.net/image/figure11.png)
    RoundEnd
    # The line continues to the point that exceeds half of the stroke width the endpoint.
    #
    # ![http://libharu.sourceforge.net/image/figure12.png](http://libharu.sourceforge.net/image/figure12.png)
    ProjectingScuareEnd
  end

  # used in `Page#line_join=`
  enum LineJoin
    # ![http://libharu.sourceforge.net/image/figure13.png](http://libharu.sourceforge.net/image/figure13.png)
    MiterJoin = 0
    # ![http://libharu.sourceforge.net/image/figure14.png](http://libharu.sourceforge.net/image/figure14.png)
    RoundJoin
    # ![http://libharu.sourceforge.net/image/figure15.png](http://libharu.sourceforge.net/image/figure15.png)
    BevelJoin
  end

  enum BlendMode
    Normal
    Multiply
    Screen
    Overlay
    Darken
    Lighten
    ColorDodge
    ColorBum
    HardLight
    SoftLight
    Difference
    Exclushon
  end

  enum TransitionStyle
    WipeRight = 0
    WipeUp
    WipeLeft
    WipeDown
    BarnDoorsHorizontalOut
    BarnDoorsHorizontalIn
    BarnDoorsVerticalOut
    BarnDoorsVerticalIn
    BoxOut
    BoxIn
    BlindsHorizontal
    BlindsVertical
    Dissolve
    GlitterRight
    GlitterDown
    GlitterTopLeftToBottomRight
    Replace
  end

  enum PageSizes
    # Size 8½ x 11 (Inches) in pixel 612 x 792
    Letter = 0
    # Size 8½ x 14 (Inches) in pixel	612 x 1008
    Legal
    # Size 297 × 420 (mm) in pixel 841.89 x 1199.551
    A3
    # Size 210 × 297 (mm) in pixel 595.276 x 841.89
    A4
    # Size 148 × 210 (mm) in pixel 419.528 x 595.276
    A5
    # Size 250 × 353 (mm) in pixel 708.661 x 1000.63
    B4
    # Size 176 × 250 (mm) in pixel 498.898 x 708.661
    B5
    # Size 7½ x 10½ (Inches) in pixel 522 x 756
    Executive
    # Size 4 x 6 (Inches) in pixel 288 x 432
    Us4x6
    # Size 4 x 8 (Inches) in pixel 288 x 576
    Us4x8
    # Size 5 x 7 (Inches) in pixel 360 x 504
    Us5x7
    # Size 4.125 x 9.5 (Inches) in pixel 297x 684
    Comm10
  end

  enum PageDirection
    # Set the longer value to horizontal.
    Portrait = 0
    # Set the longer value to vertical.
    Landscape
  end

  # set via `Doc#set_password_and_permission`.
  @[Flags]
  enum Permission
    # user can read the document.
    EnableRead = 0
    # user can print the document.
    EnablePrint = 4
    # user can edit the contents of the document other than annotations, form fields.
    EnableEditAll = 8
    # user can copy the text and the graphics of the document.
    EnableCopy = 16
     # user can add or modify the annotations and form fields of the document.
    EnableEdit = 32
  end

  # set via `Doc#compression_mode=`.
  @[Flags]
  enum CompressionMode
    # All contents are not compressed.
    None          = 0x00
    # Compress the contents stream of the page.
    Text          = 0x01
    # Compress the streams of the image objects.
    Image         = 0x02
    # Other stream datas (fonts, cmaps and so on)  are compressed.
    Metadata      = 0x04
    # All stream datas are compressed
    BestCompress  = 0x10
    BestSpeed     = 0x20
  end

  # set via `Doc#set_password_and_permission`.
  enum EncryptMode
    # Use "Revision 2" algorithm. The length of key is automatically set to 5(40bit).
    EncryptR2 = 2
    # Use "Revision 3" algorithm. Between 5(40bit) and 16(128bit) can be specified for length of the key.
    EncryptR3 = 3
  end

  # graphics mode.
  enum GMode
    None             = 0x0000
    PageDescription  = 0x0001
    PathObject       = 0x0002
    TextObject       = 0x0004
    ClippingPath     = 0x0008
    Shading          = 0x0010
    InlineImage      = 0x0020
    ExternalObject   = 0x0040
  end
end
