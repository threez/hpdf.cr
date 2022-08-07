module Hpdf
  class Exception < ::Exception
    CODES = {
      LibHaru::HPDF_ARRAY_COUNT_ERR =>  "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_ARRAY_ITEM_NOT_FOUND =>  "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_ARRAY_ITEM_UNEXPECTED_TYPE =>  "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_BINARY_LENGTH_ERR =>  "The length of the data exceeds HPDF_LIMIT_MAX_STRING_LEN.",
      LibHaru::HPDF_CANNOT_GET_PALLET =>  "Cannot get a pallet data from PNG image.",
      LibHaru::HPDF_DICT_COUNT_ERR =>  "The count of elements of a dictionary exceeds HPDF_LIMIT_MAX_DICT_ELEMENT",
      LibHaru::HPDF_DICT_ITEM_NOT_FOUND =>  "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_DICT_ITEM_UNEXPECTED_TYPE =>  "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_DICT_STREAM_LENGTH_NOT_FOUND =>  "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_DOC_ENCRYPTDICT_NOT_FOUND =>  "Doc#permission= OR Doc#encrypt_mode= was called before a password is set.",
      LibHaru::HPDF_DOC_INVALID_OBJECT =>  "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_DUPLICATE_REGISTRATION =>  "Tried to register a font that has been registered.",
      LibHaru::HPDF_EXCEED_JWW_CODE_NUM_LIMIT =>  "Cannot register a character to the japanese word wrap characters list.",
      LibHaru::HPDF_ENCRYPT_INVALID_PASSWORD =>  "Tried to set the owner password to NULL. The owner password and user password is the same.",
      LibHaru::HPDF_ERR_UNKNOWN_CLASS =>  "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_EXCEED_GSTATE_LIMIT =>  "The depth of the stack exceeded HPDF_LIMIT_MAX_GSTATE.",
      LibHaru::HPDF_FAILD_TO_ALLOC_MEM =>  "Memory allocation failed.",
      LibHaru::HPDF_FILE_IO_ERROR =>  "File processing failed. (A detailed code is set.)",
      LibHaru::HPDF_FILE_OPEN_ERROR =>  "Cannot open a file. (A detailed code is set.)",
      LibHaru::HPDF_FONT_EXISTS =>  "Tried to load a font that has been registered.",
      LibHaru::HPDF_FONT_INVALID_WIDTHS_TABLE =>  "The format of a font-file is invalid . Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_INVALID_AFM_HEADER =>  "Cannot recognize a header of an afm file.",
      LibHaru::HPDF_INVALID_ANNOTATION =>  "The specified annotation handle is invalid.",
      LibHaru::HPDF_INVALID_BIT_PER_COMPONENT =>  "Bit-per-component of a image which was set as mask-image is invalid.",
      LibHaru::HPDF_INVALID_CHAR_MATRICS_DATA =>  "Cannot recognize char-matrics-data  of an afm file.",
      LibHaru::HPDF_INVALID_COMPRESSION_MODE => "Invalid value was set when invoking Doc#commpression_mode=.",
      LibHaru::HPDF_INVALID_DATE_TIME => "An invalid date-time value was set.",
      LibHaru::HPDF_INVALID_DESTINATION => "An invalid destination handle was set.",
      LibHaru::HPDF_INVALID_DOCUMENT => "An invalid document handle is set.",
      LibHaru::HPDF_INVALID_DOCUMENT_STATE => "The function which is invalid in the present state was invoked.",
      LibHaru::HPDF_INVALID_ENCODER => "An invalid encoder handle is set.",
      LibHaru::HPDF_INVALID_ENCODER_TYPE => "A combination between font and encoder is wrong.",
      LibHaru::HPDF_INVALID_ENCODING_NAME => "An Invalid encoding name is specified.",
      LibHaru::HPDF_INVALID_ENCRYPT_KEY_LEN => "The lengh of the key of encryption is invalid.",
      LibHaru::HPDF_INVALID_FONTDEF_TYPE => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_INVALID_FONT_NAME => "A font which has the specified name is not found.",
      LibHaru::HPDF_INVALID_IMAGE => "Unsupported image format.",
      LibHaru::HPDF_INVALID_JPEG_DATA => "Unsupported image format.",
      LibHaru::HPDF_INVALID_N_DATA => "Cannot read a postscript-name from an afm file.",
      LibHaru::HPDF_INVALID_OBJ_ID => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_INVALID_OPERATION => "1. Invoked Image#color_mask= against the image-object which was set a mask-image.",
      LibHaru::HPDF_INVALID_OUTLINE => "An invalid outline-handle was specified.",
      LibHaru::HPDF_INVALID_PAGE => "An invalid page-handle was specified.",
      LibHaru::HPDF_INVALID_PAGES => "An invalid pages-handle was specified. (internel error)",
      LibHaru::HPDF_INVALID_PARAMETER => "An invalid value is set.",
      LibHaru::HPDF_INVALID_PNG_IMAGE => "Invalid PNG image format.",
      LibHaru::HPDF_INVALID_STREAM => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_MISSING_FILE_NAME_ENTRY => "Internal error. The \"_FILE_NAME\" entry for delayed loading is missing.",
      LibHaru::HPDF_INVALID_TTC_FILE => "Invalid .TTC file format.",
      LibHaru::HPDF_INVALID_TTC_INDEX => "The index parameter was exceed the number of included fonts",
      LibHaru::HPDF_INVALID_WX_DATA => "Cannot read a width-data from an afm file.",
      LibHaru::HPDF_ITEM_NOT_FOUND => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_LIBPNG_ERROR => "An error has returned from PNGLIB while loading an image.",
      LibHaru::HPDF_NAME_INVALID_VALUE => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_NAME_OUT_OF_RANGE => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_PAGES_MISSING_KIDS_ENTRY => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_PAGE_CANNOT_FIND_OBJECT => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_PAGE_CANNOT_GET_ROOT_PAGES => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_PAGE_CANNOT_RESTORE_GSTATE => "There are no graphics-states to be restored.",
      LibHaru::HPDF_PAGE_CANNOT_SET_PARENT => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_PAGE_FONT_NOT_FOUND => "The current font is not set.",
      LibHaru::HPDF_PAGE_INVALID_FONT => "An invalid font-handle was spacified.",
      LibHaru::HPDF_PAGE_INVALID_FONT_SIZE => "An invalid font-size was set.",
      LibHaru::HPDF_PAGE_INVALID_GMODE => "See Graphics mode.",
      LibHaru::HPDF_PAGE_INVALID_INDEX => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_PAGE_INVALID_ROTATE_VALUE => "The specified value is not a multiple of 90.",
      LibHaru::HPDF_PAGE_INVALID_SIZE => "An invalid page-size was set.",
      LibHaru::HPDF_PAGE_INVALID_XOBJECT => "An invalid image-handle was set.",
      LibHaru::HPDF_PAGE_OUT_OF_RANGE => "The specified value is out of range.",
      LibHaru::HPDF_REAL_OUT_OF_RANGE => "The specified value is out of range.",
      LibHaru::HPDF_STREAM_EOF => "Unexpected EOF marker was detected.",
      LibHaru::HPDF_STREAM_READLN_CONTINUE => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_STRING_OUT_OF_RANGE => "The length of the specified text is too long.",
      LibHaru::HPDF_THIS_FUNC_WAS_SKIPPED => "The execution of a function was skipped because of other errors.",
      LibHaru::HPDF_TTF_CANNOT_EMBEDDING_FONT => "This font cannot be embedded. (restricted by license)",
      LibHaru::HPDF_TTF_INVALID_CMAP => "Unsupported ttf format. (cannot find unicode cmap.)",
      LibHaru::HPDF_TTF_INVALID_FOMAT => "Unsupported ttf format.",
      LibHaru::HPDF_TTF_MISSING_TABLE => "Unsupported ttf format. (cannot find a necessary table)",
      LibHaru::HPDF_UNSUPPORTED_FONT_TYPE => "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_UNSUPPORTED_JPEG_FORMAT =>  "Unsupported Jpeg format.",
      LibHaru::HPDF_UNSUPPORTED_TYPE1_FONT =>  "Failed to parse .PFB file.",
      LibHaru::HPDF_XREF_COUNT_ERR =>  "Internal error. The consistency of the data was lost.",
      LibHaru::HPDF_ZLIB_ERROR =>  "An error has occurred while executing a function of Zlib.",
      LibHaru::HPDF_INVALID_PAGE_INDEX =>  "An error returned from Zlib.",
      LibHaru::HPDF_INVALID_URI =>  "An invalid URI was set.",
      LibHaru::HPDF_PAGELAYOUT_OUT_OF_RANGE =>  "An invalid page-layout was set.",
      LibHaru::HPDF_PAGEMODE_OUT_OF_RANGE =>  "An invalid page-mode was set.",
      LibHaru::HPDF_PAGENUM_STYLE_OUT_OF_RANGE =>  "An invalid page-num-style was set.",
      LibHaru::HPDF_ANNOT_INVALID_ICON =>  "An invalid icon was set.",
      LibHaru::HPDF_ANNOT_INVALID_BORDER_STYLE =>  "An invalid border-style was set.",
      LibHaru::HPDF_PAGE_INVALID_DIRECTION =>  "An invalid page-direction was set.",
      LibHaru::HPDF_INVALID_FONT =>  "An invalid font-handle was specified.",
    }

    def self.errcode(error_no, detail_no) : Exception
      if msg = CODES[error_no]?
        return new msg
      end

      case error_no
      when LibHaru::HPDF_INVALID_COLOR_SPACE
        detail_error error_no, "color space", detail_no, {
          1 => "The color_space parameter of HPDF_LoadRawImage is invalid.",
          2 => "Color-space of a image which was set as mask-image is invalid.",
          3 => "The function which is invalid in the present color-space was invoked.",
        }
      when LibHaru::HPDF_INVALID_FONTDEF_DATA
        detail_error error_no, "invalid font data", detail_no, {
          1 => "An invalid font handle was set.",
          2 => "Unsupported font format.",
        }
      when LibHaru::HPDF_INVALID_OBJECT
        detail_error error_no, "invalid object", detail_no, {
          1 => "An invalid object is set.",
          2 => "Internal error. The consistency of the data was lost.",
        }
      when LibHaru::HPDF_UNSUPPORTED_FUNC
        detail_error error_no, "unsupported function", detail_no, {
          1 => "The library is not configured to use PNGLIB.",
          2 => "Internal error. The consistency of the data was lost.",
        }
      else
        new("ERROR generic: error_no=%04x, detail_no=%d" % [error_no, detail_no])
      end
    end

    def self.detail_error(error_no, name, detail_no, details)
      if msg = details[detail_no]?
        new msg
      else
        new("ERROR #{name}: error_no=%04x, detail_no=%d" % [error_no, detail_no])
      end
    end
  end
end
