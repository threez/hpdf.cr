module Hpdf
  class Exception < ::Exception
    def self.errcode(error_no, detail_no) : Exception
      case error_no
      when LibHaru::HPDF_ARRAY_COUNT_ERR
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_ARRAY_ITEM_NOT_FOUND
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_ARRAY_ITEM_UNEXPECTED_TYPE
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_BINARY_LENGTH_ERR
        new "The length of the data exceeds HPDF_LIMIT_MAX_STRING_LEN."
      when LibHaru::HPDF_CANNOT_GET_PALLET
        new "Cannot get a pallet data from PNG image."
      when LibHaru::HPDF_DICT_COUNT_ERR
        new "The count of elements of a dictionary exceeds HPDF_LIMIT_MAX_DICT_ELEMENT"
      when LibHaru::HPDF_DICT_ITEM_NOT_FOUND
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_DICT_ITEM_UNEXPECTED_TYPE
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_DICT_STREAM_LENGTH_NOT_FOUND
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_DOC_ENCRYPTDICT_NOT_FOUND
        new "Doc#permission= OR Doc#encrypt_mode= was called before a password is set."
      when LibHaru::HPDF_DOC_INVALID_OBJECT
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_DUPLICATE_REGISTRATION
        new "Tried to register a font that has been registered."
      when LibHaru::HPDF_EXCEED_JWW_CODE_NUM_LIMIT
        new "Cannot register a character to the japanese word wrap characters list."
      when LibHaru::HPDF_ENCRYPT_INVALID_PASSWORD
        new "Tried to set the owner password to NULL. The owner password and user password is the same."
      when LibHaru::HPDF_ERR_UNKNOWN_CLASS
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_EXCEED_GSTATE_LIMIT
        new "The depth of the stack exceeded HPDF_LIMIT_MAX_GSTATE."
      when LibHaru::HPDF_FAILD_TO_ALLOC_MEM
        new "Memory allocation failed."
      when LibHaru::HPDF_FILE_IO_ERROR
        new "File processing failed. (A detailed code is set.)"
      when LibHaru::HPDF_FILE_OPEN_ERROR
        new "Cannot open a file. (A detailed code is set.)"
      when LibHaru::HPDF_FONT_EXISTS
        new "Tried to load a font that has been registered."
      when LibHaru::HPDF_FONT_INVALID_WIDTHS_TABLE
        new "The format of a font-file is invalid . Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_INVALID_AFM_HEADER
        new "Cannot recognize a header of an afm file."
      when LibHaru::HPDF_INVALID_ANNOTATION
        new "The specified annotation handle is invalid."
      when LibHaru::HPDF_INVALID_BIT_PER_COMPONENT
        new "Bit-per-component of a image which was set as mask-image is invalid."
      when LibHaru::HPDF_INVALID_CHAR_MATRICS_DATA
        new "Cannot recognize char-matrics-data  of an afm file."
      when LibHaru::HPDF_INVALID_COLOR_SPACE
        case detail_no
        when 1
          new "The color_space parameter of HPDF_LoadRawImage is invalid."
        when 2
          new "Color-space of a image which was set as mask-image is invalid."
        when 3
          new "The function which is invalid in the present color-space was invoked."
        else
          new("ERROR color space: error_no=%04x, detail_no=%d" % [error_no, detail_no])
        end
      when LibHaru::HPDF_INVALID_COMPRESSION_MODE
        new "Invalid value was set when invoking Doc#commpression_mode=."
      when LibHaru::HPDF_INVALID_DATE_TIME
        new "An invalid date-time value was set."
      when LibHaru::HPDF_INVALID_DESTINATION
        new "An invalid destination handle was set."
      when LibHaru::HPDF_INVALID_DOCUMENT
        new "An invalid document handle is set."
      when LibHaru::HPDF_INVALID_DOCUMENT_STATE
        new "The function which is invalid in the present state was invoked."
      when LibHaru::HPDF_INVALID_ENCODER
        new "An invalid encoder handle is set."
      when LibHaru::HPDF_INVALID_ENCODER_TYPE
        new "A combination between font and encoder is wrong."
      when LibHaru::HPDF_INVALID_ENCODING_NAME
        new "An Invalid encoding name is specified."
      when LibHaru::HPDF_INVALID_ENCRYPT_KEY_LEN
        new "The lengh of the key of encryption is invalid."
      when LibHaru::HPDF_INVALID_FONTDEF_DATA
        case detail_no
        when 1
          new "An invalid font handle was set."
        when 2
          new "Unsupported font format."
        else
          new("ERROR invalid font data: error_no=%04x, detail_no=%d" % [error_no, detail_no])
        end
      when LibHaru::HPDF_INVALID_FONTDEF_TYPE
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_INVALID_FONT_NAME
        new "A font which has the specified name is not found."
      when LibHaru::HPDF_INVALID_IMAGE
        new "Unsupported image format."
      when LibHaru::HPDF_INVALID_JPEG_DATA
        new "Unsupported image format."
      when LibHaru::HPDF_INVALID_N_DATA
        new "Cannot read a postscript-name from an afm file."
      when LibHaru::HPDF_INVALID_OBJECT
        case detail_no
        when 1
          new "An invalid object is set."
        when 2
          new "Internal error. The consistency of the data was lost."
        else
          new("ERROR invalid object: error_no=%04x, detail_no=%d" % [error_no, detail_no])
        end
      when LibHaru::HPDF_INVALID_OBJ_ID
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_INVALID_OPERATION
        new "1. Invoked Image#color_mask= against the image-object which was set a mask-image."
      when LibHaru::HPDF_INVALID_OUTLINE
        new "An invalid outline-handle was specified."
      when LibHaru::HPDF_INVALID_PAGE
        new "An invalid page-handle was specified."
      when LibHaru::HPDF_INVALID_PAGES
        new "An invalid pages-handle was specified. (internel error)"
      when LibHaru::HPDF_INVALID_PARAMETER
        new "An invalid value is set."
      when LibHaru::HPDF_INVALID_PNG_IMAGE
        new "Invalid PNG image format."
      when LibHaru::HPDF_INVALID_STREAM
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_MISSING_FILE_NAME_ENTRY
        new "Internal error. The \"_FILE_NAME\" entry for delayed loading is missing."
      when LibHaru::HPDF_INVALID_TTC_FILE
        new "Invalid .TTC file format."
      when LibHaru::HPDF_INVALID_TTC_INDEX
        new "The index parameter was exceed the number of included fonts"
      when LibHaru::HPDF_INVALID_WX_DATA
        new "Cannot read a width-data from an afm file."
      when LibHaru::HPDF_ITEM_NOT_FOUND
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_LIBPNG_ERROR
        new "An error has returned from PNGLIB while loading an image."
      when LibHaru::HPDF_NAME_INVALID_VALUE
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_NAME_OUT_OF_RANGE
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_PAGES_MISSING_KIDS_ENTRY
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_PAGE_CANNOT_FIND_OBJECT
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_PAGE_CANNOT_GET_ROOT_PAGES
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_PAGE_CANNOT_RESTORE_GSTATE
        new "There are no graphics-states to be restored."
      when LibHaru::HPDF_PAGE_CANNOT_SET_PARENT
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_PAGE_FONT_NOT_FOUND
        new "The current font is not set."
      when LibHaru::HPDF_PAGE_INVALID_FONT
        new "An invalid font-handle was spacified."
      when LibHaru::HPDF_PAGE_INVALID_FONT_SIZE
        new "An invalid font-size was set."
      when LibHaru::HPDF_PAGE_INVALID_GMODE
        new "See Graphics mode."
      when LibHaru::HPDF_PAGE_INVALID_INDEX
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_PAGE_INVALID_ROTATE_VALUE
        new "The specified value is not a multiple of 90."
      when LibHaru::HPDF_PAGE_INVALID_SIZE
        new "An invalid page-size was set."
      when LibHaru::HPDF_PAGE_INVALID_XOBJECT
        new "An invalid image-handle was set."
      when LibHaru::HPDF_PAGE_OUT_OF_RANGE
        new "The specified value is out of range."
      when LibHaru::HPDF_REAL_OUT_OF_RANGE
        new "The specified value is out of range."
      when LibHaru::HPDF_STREAM_EOF
        new "Unexpected EOF marker was detected."
      when LibHaru::HPDF_STREAM_READLN_CONTINUE
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_STRING_OUT_OF_RANGE
        new "The length of the specified text is too long."
      when LibHaru::HPDF_THIS_FUNC_WAS_SKIPPED
        new "The execution of a function was skipped because of other errors."
      when LibHaru::HPDF_TTF_CANNOT_EMBEDDING_FONT
        new "This font cannot be embedded. (restricted by license)"
      when LibHaru::HPDF_TTF_INVALID_CMAP
        new "Unsupported ttf format. (cannot find unicode cmap.)"
      when LibHaru::HPDF_TTF_INVALID_FOMAT
        new "Unsupported ttf format."
      when LibHaru::HPDF_TTF_MISSING_TABLE
        new "Unsupported ttf format. (cannot find a necessary table)"
      when LibHaru::HPDF_UNSUPPORTED_FONT_TYPE
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_UNSUPPORTED_FUNC
        case detail_no
        when 1
          new "The library is not configured to use PNGLIB."
        when 2
          new "Internal error. The consistency of the data was lost."
        else
          new("ERROR unsupported function: error_no=%04x, detail_no=%d" % [error_no, detail_no])
        end
      when LibHaru::HPDF_UNSUPPORTED_JPEG_FORMAT
        new "Unsupported Jpeg format."
      when LibHaru::HPDF_UNSUPPORTED_TYPE1_FONT
        new "Failed to parse .PFB file."
      when LibHaru::HPDF_XREF_COUNT_ERR
        new "Internal error. The consistency of the data was lost."
      when LibHaru::HPDF_ZLIB_ERROR
        new "An error has occurred while executing a function of Zlib."
      when LibHaru::HPDF_INVALID_PAGE_INDEX
        new "An error returned from Zlib."
      when LibHaru::HPDF_INVALID_URI
        new "An invalid URI was set."
      when LibHaru::HPDF_PAGELAYOUT_OUT_OF_RANGE
        new "An invalid page-layout was set."
      when LibHaru::HPDF_PAGEMODE_OUT_OF_RANGE
        new "An invalid page-mode was set."
      when LibHaru::HPDF_PAGENUM_STYLE_OUT_OF_RANGE
        new "An invalid page-num-style was set."
      when LibHaru::HPDF_ANNOT_INVALID_ICON
        new "An invalid icon was set."
      when LibHaru::HPDF_ANNOT_INVALID_BORDER_STYLE
        new "An invalid border-style was set."
      when LibHaru::HPDF_PAGE_INVALID_DIRECTION
        new "An invalid page-direction was set."
      when LibHaru::HPDF_INVALID_FONT
        new "An invalid font-handle was specified."
      else
        new("ERROR generic: error_no=%04x, detail_no=%d" % [error_no, detail_no])
      end
    end
  end
end
