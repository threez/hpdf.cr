@[Link("hpdf")]
lib LibHaru
  type Doc = Void*
  type Page = Void*
  type Image = Void*
  type Font = Void*
  type Encoding = Void*
  type Outline = Void*
  type Destination = Void*
  type Annotation = Void*

  alias Real = LibC::Float
  alias Status = LibC::ULong
  alias UInt = LibC::UInt
  alias Int = LibC::Int
  alias Bool = LibC::UInt
  alias Double = LibC::Double

  # Document handling
  fun new = HPDF_New((Status, Status, Void*) -> Void, Void*) : Doc
  fun free = HPDF_Free(Doc) : Void
  fun save_to_file = HPDF_SaveToFile(Doc, LibC::Char*) : Status
  fun save_to_stream = HPDF_SaveToStream(Doc) : Void
  fun get_stream_size = HPDF_GetStreamSize(Doc) : UInt
  fun read_from_stream = HPDF_ReadFromStream(Doc, LibC::Char*, UInt*) : Status
  fun reset_stream = HPDF_ResetStream(Doc) : Status
  fun set_pages_configuration = HPDF_SetPagesConfiguration(Doc, UInt) : Status
  fun set_page_layout = HPDF_SetPageLayout(Doc, UInt) : Status
  fun get_page_layout = HPDF_GetPageLayout(Doc) : UInt
  fun set_page_mode = HPDF_SetPageMode(Doc, UInt) : Status
  fun get_page_mode = HPDF_GetPageMode(Doc) : UInt
  # TODO fun set_open_action = HPDF_SetOpenAction
  fun get_current_page = HPDF_GetCurrentPage(Doc) : Page
  fun add_page = HPDF_AddPage(Doc) : Page
  fun insert_page = HPDF_InsertPage(Doc, Page) : Page
  fun get_font = HPDF_GetFont(Doc, LibC::Char*, LibC::Char*) : Font
  fun load_type1_font_from_file = HPDF_LoadType1FontFromFile(Doc, LibC::Char*, LibC::Char*) : LibC::Char*
  fun load_tt_font_from_file = HPDF_LoadTTFontFromFile(Doc, LibC::Char*, Bool) : LibC::Char*
  fun load_tt_font_from_file2 = HPDF_LoadTTFontFromFile2(Doc, LibC::Char*, UInt, Bool) : Status
  fun add_page_label = HPDF_AddPageLabel(Doc, UInt, UInt, UInt, LibC::Char*) : Status
  fun use_jp_fonts = HPDF_UseJPFonts(Doc) : Status
  fun use_kr_fonts = HPDF_UseKRFonts(Doc) : Status
  fun use_cns_fonts = HPDF_UseCNSFonts(Doc) : Status
  fun use_cnt_fonts = HPDF_UseCNTFonts(Doc) : Status
  # TODO fun create_outline = HPDF_CreateOutline
  # TODO fun get_encoder = HPDF_GetEncoder
  # TODO fun get_current_encoder = HPDF_GetCurrentEncoder
  # TODO fun set_current_encoder = HPDF_SetCurrentEncoder
  fun use_jp_encodings = HPDF_UseJPEncodings(Doc) : Status
  fun use_kr_encodings = HPDF_UseKREncodings(Doc) : Status
  fun use_cns_encodings = HPDF_UseCNSEncodings(Doc) : Status
  fun use_cnt_encodings = HPDF_UseCNTEncodings(Doc) : Status
  fun load_png_image_from_file = HPDF_LoadPngImageFromFile(Doc, LibC::Char*) : Image
  fun load_png_image_from_file2 = HPDF_LoadPngImageFromFile2(Doc, LibC::Char*) : Image
  fun load_raw_image_from_file = HPDF_LoadRawImageFromFile(Doc, LibC::Char*, UInt, UInt, UInt) : Image
  fun load_raw_image_from_mem = HPDF_LoadRawImageFromMem(Doc, LibC::Char*, UInt, UInt, UInt, UInt) : Image
  fun load_jpeg_image_from_file = HPDF_LoadJpegImageFromFile(Doc, LibC::Char*) : Image
  fun set_info_attr = HPDF_SetInfoAttr(Doc, UInt, LibC::Char*) : Status
  fun get_info_attr = HPDF_GetInfoAttr(Doc, UInt) : LibC::Char*
  struct Date
    year : Int
    month : Int       # between 1 and 12.
    day : Int         # between 1 and ether of 28, 29, 30, 31. (It is different by the month.)
    hour : Int        #  0 to 23
    minutes : Int     # 0 to 59
    seconds : Int     # 0 to 59
    ind : Char        # the relationship of local time to Universal Time. " ", +, −, and Z are available.
    off_hour : Int    # if ind is not space, 0 to 23 is valid. Otherwise, this value is ignored.
    off_minutes : Int # if ind is not space, 0 to 59 is valid. Otherwise, this value is ignored.
  end
  fun set_info_date_attr = HPDF_SetInfoDateAttr(Doc, UInt, Date) : Status
  fun set_password = HPDF_SetPassword(Doc, LibC::Char*, LibC::Char*) : Status
  fun set_permission = HPDF_SetPermission(Doc, UInt) : Status

  # Page handling

  # Graphics

  # Font handling
  fun font_get_font_name = HPDF_Font_GetFontName(Font) : LibC::Char*
  fun font_get_encoding_name = HPDF_Font_GetEncodingName(Font) : LibC::Char*
  fun font_get_unicode_width = HPDF_Font_GetUnicodeWidth(Font, UInt16) : Int
  struct Rect
    left : Real
    bottom : Real
    right : Real
    top : Real
  end
  fun font_get_b_box = HPDF_Font_GetBBox(Font) : Rect
  fun font_get_ascent = HPDF_Font_GetAscent(Font) : Int
  fun font_get_descent = HPDF_Font_GetDescent(Font) : Int
  fun font_get_x_height = HPDF_Font_GetXHeight(Font) : UInt
  fun font_get_cap_height = HPDF_Font_GetXHeight(Font) : UInt
  struct TextWidth
    numchars : UInt
    numwords : UInt
    width : UInt
    numspace : UInt
  end
  fun font_text_width = HPDF_Font_TextWidth(Font, LibC::Char*, UInt) : TextWidth
  fun font_measure_text = HPDF_Font_MeasureText(Font, LibC::Char*, UInt, Real, Real, Real, Real, Bool, Real*) : UInt

  # Encoding

  # Annotation

  # Outline

  # Destination

  # Image
  struct Point
    x : Real
    y : Real
  end
  fun image_get_size = HPDF_Image_GetSize(Image) : Point
  fun image_get_width = HPDF_Image_GetWidth(Image) : UInt
  fun image_get_height = HPDF_Image_GetHeight(Image) : UInt
  fun image_get_bits_per_component = HPDF_Image_GetBitsPerComponent(Image) : UInt
  fun image_get_color_space = HPDF_Image_GetColorSpace(Image) : LibC::Char*
  fun image_set_color_mask = HPDF_Image_SetColorMask(Image, UInt, UInt, UInt, UInt, UInt, UInt) : Status
  fun image_set_mask_image = HPDF_Image_SetMaskImage(Image, Image) : Status



  fun page_set_text_leading = HPDF_Page_SetTextLeading(Page, Real) : Status
  fun page_show_text_next_line = HPDF_Page_ShowTextNextLine(Page, LibC::Char*) : Status

  fun page_get_height = HPDF_Page_GetHeight(Page) : Real
  fun page_get_width = HPDF_Page_GetWidth(Page) : Real
  fun page_set_line_width = HPDF_Page_SetLineWidth(Page, Real) : Void
  fun page_rectangle = HPDF_Page_Rectangle(Page, Real, Real, Real, Real) : Void

  fun page_move_to = HPDF_Page_MoveTo(Page, Real, Real) : Status
  fun page_line_to = HPDF_Page_LineTo(Page, Real, Real) : Status
  fun page_set_dash = HPDF_Page_SetDash(Page, UInt16*, UInt, UInt) : Status
  fun page_set_rgb_stroke = HPDF_Page_SetRGBStroke (Page, Real, Real, Real) : Status
  fun page_set_rgb_fill = HPDF_Page_SetRGBFill (Page, Real, Real, Real) : Status

  fun page_set_line_cap = HPDF_Page_SetLineCap(Page, UInt) : Status
  fun page_set_line_join = HPDF_Page_SetLineJoin(Page, UInt) : Status

  fun page_stroke = HPDF_Page_Stroke(Page) : Void
  fun page_fill = HPDF_Page_Fill(Page) : Void
  fun page_fill_stroke = HPDF_Page_FillStroke(Page) : Void
  fun page_gsave = HPDF_Page_GSave(Page) : Void
  fun page_grestore = HPDF_Page_GRestore(Page) : Void
  fun page_clip = HPDF_Page_Clip(Page) : Void
  fun page_set_font_and_size = HPDF_Page_SetFontAndSize(Page, Font, Real) : Status
  fun page_text_width = HPDF_Page_TextWidth(Page, LibC::Char*) : Real
  fun page_begin_text = HPDF_Page_BeginText(Page) : Status
  fun page_text_out = HPDF_Page_TextOut(Page, Real, Real, LibC::Char*) : Status
  fun page_end_text = HPDF_Page_EndText(Page) : Status
  fun page_move_text_pos = HPDF_Page_MoveTextPos(Page, Real, Real) : Status
  fun page_show_text = HPDF_Page_ShowText (Page, LibC::Char*) : Status

  fun page_curve_to = HPDF_Page_CurveTo(Page, Real, Real, Real, Real, Real, Real) : Status
  fun page_curve_to2 = HPDF_Page_CurveTo2(Page, Real, Real, Real, Real) : Status
  fun page_curve_to3 = HPDF_Page_CurveTo3(Page, Real, Real, Real, Real) : Status
  fun page_draw_image = HPDF_Page_DrawImage(Page, Image, Real, Real, Real, Real) : Status

  HPDF_ARRAY_COUNT_ERR             = 0x1001 #	Internal error. The consistency of the data was lost.
  HPDF_ARRAY_ITEM_NOT_FOUND        = 0x1002 #	Internal error. The consistency of the data was lost.
  HPDF_ARRAY_ITEM_UNEXPECTED_TYPE  = 0x1003 #	Internal error. The consistency of the data was lost.
  HPDF_BINARY_LENGTH_ERR           = 0x1004 #	The length of the data exceeds HPDF_LIMIT_MAX_STRING_LEN.
  HPDF_CANNOT_GET_PALLET           = 0x1005 #	Cannot get a pallet data from PNG image.
  # 0x1006 	#
  HPDF_DICT_COUNT_ERR              = 0x1007 #	The count of elements of a dictionary exceeds HPDF_LIMIT_MAX_DICT_ELEMENT
  HPDF_DICT_ITEM_NOT_FOUND         = 0x1008 #	Internal error. The consistency of the data was lost.
  HPDF_DICT_ITEM_UNEXPECTED_TYPE   = 0x1009 #	Internal error. The consistency of the data was lost.
  HPDF_DICT_STREAM_LENGTH_NOT_FOUND= 0x100A #	Internal error. The consistency of the data was lost.
  HPDF_DOC_ENCRYPTDICT_NOT_FOUND   = 0x100B #	HPDF_SetPermission() OR HPDF_SetEncryptMode() was called before a password is set.
  HPDF_DOC_INVALID_OBJECT          = 0x100C #	Internal error. The consistency of the data was lost.
  # 0x100D 	#
  HPDF_DUPLICATE_REGISTRATION      = 0x100E #	Tried to register a font that has been registered.
  HPDF_EXCEED_JWW_CODE_NUM_LIMIT   = 0x100F #	Cannot register a character to the japanese word wrap characters list.
  # 0x1010 	#
  HPDF_ENCRYPT_INVALID_PASSWORD    = 0x1011 #	Tried to set the owner password to NULL. The owner password and user password is the same.
  HPDF_ERR_UNKNOWN_CLASS           = 0x1013 #	Internal error. The consistency of the data was lost.
  HPDF_EXCEED_GSTATE_LIMIT         = 0x1014 #	The depth of the stack exceeded HPDF_LIMIT_MAX_GSTATE.
  HPDF_FAILD_TO_ALLOC_MEM          = 0x1015 #	Memory allocation failed.
  HPDF_FILE_IO_ERROR               = 0x1016 #	File processing failed. (A detailed code is set.)
  HPDF_FILE_OPEN_ERROR             = 0x1017 #	Cannot open a file. (A detailed code is set.)
  # 0x1018 	#
  HPDF_FONT_EXISTS                 = 0x1019 #	Tried to load a font that has been registered.
  HPDF_FONT_INVALID_WIDTHS_TABLE   = 0x101A #	The format of a font-file is invalid . Internal error. The consistency of the data was lost.
  HPDF_INVALID_AFM_HEADER          = 0x101B #	Cannot recognize a header of an afm file.
  HPDF_INVALID_ANNOTATION          = 0x101C #	The specified annotation handle is invalid.
  # 0x101D 	#
  HPDF_INVALID_BIT_PER_COMPONENT   = 0x101E #	Bit-per-component of a image which was set as mask-image is invalid.
  HPDF_INVALID_CHAR_MATRICS_DATA   = 0x101F #	Cannot recognize char-matrics-data  of an afm file.
  HPDF_INVALID_COLOR_SPACE         = 0x1020 #	1. The color_space parameter of HPDF_LoadRawImage is invalid.
                                            #  2. Color-space of a image which was set as mask-image is invalid.
                                            #  3. The function which is invalid in the present color-space was invoked.
  HPDF_INVALID_COMPRESSION_MODE    = 0x1021 #	Invalid value was set when invoking HPDF_SetCommpressionMode().
  HPDF_INVALID_DATE_TIME           = 0x1022 #	An invalid date-time value was set.
  HPDF_INVALID_DESTINATION         = 0x1023 #	An invalid destination handle was set.
  # 0x1024 	#
  HPDF_INVALID_DOCUMENT            = 0x1025 #	An invalid document handle is set.
  HPDF_INVALID_DOCUMENT_STATE      = 0x1026 #	The function which is invalid in the present state was invoked.
  HPDF_INVALID_ENCODER             = 0x1027 #	An invalid encoder handle is set.
  HPDF_INVALID_ENCODER_TYPE        = 0x1028 #	A combination between font and encoder is wrong.
  # 0x1029 	#
  # 0x102A 	#
  HPDF_INVALID_ENCODING_NAME       = 0x102B #	An Invalid encoding name is specified.
  HPDF_INVALID_ENCRYPT_KEY_LEN     = 0x102C #	The lengh of the key of encryption is invalid.
  HPDF_INVALID_FONTDEF_DATA        = 0x102D #	1. An invalid font handle was set.
                                            #  2. Unsupported font format.
  HPDF_INVALID_FONTDEF_TYPE        = 0x102E #	Internal error. The consistency of the data was lost.
  HPDF_INVALID_FONT_NAME           = 0x102F #	A font which has the specified name is not found.
  HPDF_INVALID_IMAGE               = 0x1030 #	Unsupported image format.
  HPDF_INVALID_JPEG_DATA           = 0x1031 #	Unsupported image format.
  HPDF_INVALID_N_DATA              = 0x1032 #	Cannot read a postscript-name from an afm file.
  HPDF_INVALID_OBJECT              = 0x1033 #	1. An invalid object is set.
                                            #  2. Internal error. The consistency of the data was lost.
  HPDF_INVALID_OBJ_ID              = 0x1034 #	Internal error. The consistency of the data was lost.
  HPDF_INVALID_OPERATION           = 0x1035 #	1. Invoked HPDF_Image_SetColorMask() against the image-object which was set a mask-image.
  HPDF_INVALID_OUTLINE             = 0x1036 #	An invalid outline-handle was specified.
  HPDF_INVALID_PAGE                = 0x1037 #	An invalid page-handle was specified.
  HPDF_INVALID_PAGES               = 0x1038 #	An invalid pages-handle was specified. (internel error)
  HPDF_INVALID_PARAMETER           = 0x1039 #	An invalid value is set.
  # 0x103A 	#
  HPDF_INVALID_PNG_IMAGE           = 0x103B #	Invalid PNG image format.
  HPDF_INVALID_STREAM              = 0x103C #	Internal error. The consistency of the data was lost.
  HPDF_MISSING_FILE_NAME_ENTRY     = 0x103D #	Internal error. The "_FILE_NAME" entry for delayed loading is missing.
  # 0x103E 	#
  HPDF_INVALID_TTC_FILE            = 0x103F #	Invalid .TTC file format.
  HPDF_INVALID_TTC_INDEX           = 0x1040 #	The index parameter was exceed the number of included fonts
  HPDF_INVALID_WX_DATA             = 0x1041 #	Cannot read a width-data from an afm file.
  HPDF_ITEM_NOT_FOUND              = 0x1042 #	Internal error. The consistency of the data was lost.
  HPDF_LIBPNG_ERROR                = 0x1043 #	An error has returned from PNGLIB while loading an image.
  HPDF_NAME_INVALID_VALUE          = 0x1044 #	Internal error. The consistency of the data was lost.
  HPDF_NAME_OUT_OF_RANGE           = 0x1045 #	Internal error. The consistency of the data was lost.
  # 0x1046 	#
  # 0x1047 	#
  # 0x1048 	#
  HPDF_PAGES_MISSING_KIDS_ENTRY    = 0x1049 #	Internal error. The consistency of the data was lost.
  HPDF_PAGE_CANNOT_FIND_OBJECT     = 0x104A #	Internal error. The consistency of the data was lost.
  HPDF_PAGE_CANNOT_GET_ROOT_PAGES  = 0x104B #	Internal error. The consistency of the data was lost.
  HPDF_PAGE_CANNOT_RESTORE_GSTATE  = 0x104C #	There are no graphics-states to be restored.
  HPDF_PAGE_CANNOT_SET_PARENT      = 0x104D #	Internal error. The consistency of the data was lost.
  HPDF_PAGE_FONT_NOT_FOUND         = 0x104E #	The current font is not set.
  HPDF_PAGE_INVALID_FONT           = 0x104F #	An invalid font-handle was spacified.
  HPDF_PAGE_INVALID_FONT_SIZE      = 0x1050 #	An invalid font-size was set.
  HPDF_PAGE_INVALID_GMODE          = 0x1051 #	See Graphics mode.
  HPDF_PAGE_INVALID_INDEX          = 0x1052 #	Internal error. The consistency of the data was lost.
  HPDF_PAGE_INVALID_ROTATE_VALUE   = 0x1053 #	The specified value is not a multiple of 90.
  HPDF_PAGE_INVALID_SIZE           = 0x1054 #	An invalid page-size was set.
  HPDF_PAGE_INVALID_XOBJECT        = 0x1055 #	An invalid image-handle was set.
  HPDF_PAGE_OUT_OF_RANGE           = 0x1056 #	The specified value is out of range.
  HPDF_REAL_OUT_OF_RANGE           = 0x1057 #	The specified value is out of range.
  HPDF_STREAM_EOF                  = 0x1058 #	Unexpected EOF marker was detected.
  HPDF_STREAM_READLN_CONTINUE      = 0x1059 #	Internal error. The consistency of the data was lost.
  # 0x105A 	#
  HPDF_STRING_OUT_OF_RANGE         = 0x105B #	The length of the specified text is too long.
  HPDF_THIS_FUNC_WAS_SKIPPED       = 0x105C #	The execution of a function was skipped because of other errors.
  HPDF_TTF_CANNOT_EMBEDDING_FONT   = 0x105D #	This font cannot be embedded. (restricted by license)
  HPDF_TTF_INVALID_CMAP            = 0x105E #	Unsupported ttf format. (cannot find unicode cmap.)
  HPDF_TTF_INVALID_FOMAT           = 0x105F #	Unsupported ttf format.
  HPDF_TTF_MISSING_TABLE           = 0x1060 #	Unsupported ttf format. (cannot find a necessary table)
  HPDF_UNSUPPORTED_FONT_TYPE       = 0x1061 #	Internal error. The consistency of the data was lost.
  HPDF_UNSUPPORTED_FUNC            = 0x1062 #	1. The library is not configured to use PNGLIB.
                                            # 2. Internal error. The consistency of the data was lost.
  HPDF_UNSUPPORTED_JPEG_FORMAT     = 0x1063 #	Unsupported Jpeg format.
  HPDF_UNSUPPORTED_TYPE1_FONT      = 0x1064 #	Failed to parse .PFB file.
  HPDF_XREF_COUNT_ERR              = 0x1065 #	Internal error. The consistency of the data was lost.
  HPDF_ZLIB_ERROR                  = 0x1066 #	An error has occurred while executing a function of Zlib.
  HPDF_INVALID_PAGE_INDEX          = 0x1067 #	An error returned from Zlib.
  HPDF_INVALID_URI                 = 0x1068 #	An invalid URI was set.
  HPDF_PAGELAYOUT_OUT_OF_RANGE     = 0x1069 #	An invalid page-layout was set.
  HPDF_PAGEMODE_OUT_OF_RANGE       = 0x1070 #	An invalid page-mode was set.
  HPDF_PAGENUM_STYLE_OUT_OF_RANGE  = 0x1071 #	An invalid page-num-style was set.
  HPDF_ANNOT_INVALID_ICON          = 0x1072 #	An invalid icon was set.
  HPDF_ANNOT_INVALID_BORDER_STYLE  = 0x1073 #	An invalid border-style was set.
  HPDF_PAGE_INVALID_DIRECTION      = 0x1074 #	An invalid page-direction was set.
  HPDF_INVALID_FONT                = 0x1075 #	An invalid font-handle was specified.
end
