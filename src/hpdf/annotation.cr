require "./helper"

module Hpdf
  # There are three type of annotation-object on Haru. First is the text-annotation which represents a
  # "sticky note". Second is the link-annotation which represents a hypertext link to a destination.
  # And third is the URI-link-annotation which represents a hypertext link to a web page.
  # The annotation handle is used to set properties of an annotation object.
  class Annotation
    include Helper

    def initialize(@annotation : LibHaru::Annotation, @doc : Doc, @page : Page)
    end

    def to_unsafe
      @annotation
    end
  end

  class LinkAnnotation < Annotation
    # defined the appearance of when a mouse clicked on a
    # link annotation.
    def highlight_mode=(mode : AnnotationHighlightMode)
      LibHaru.link_annot_set_highlight_mode(self, mode.to_i)
    end

    # defines the style of the annotation's border.
    #
    # * *width* the width of an annotation's border.
    # * *dash_on*, *dash_off* the dash style.
    def set_border_style(width : Number, dash_on : UInt16, dash_off : UInt16)
      LibHaru.link_annot_set_border_style(self, real(width), dash_on, dash_off)
    end
  end

  class TextAnnotation < Annotation
    # defines the style of the annotation's icon.
    #
    # * *icon* the style of icon.
    def icon=(icon : AnnotationIcon)
      LibHaru.text_annot_set_icon(self, icon.to_i)
    end

    # defines whether the text-annotation is initially displayed open.
    #
    # * *opened* `true` means that the annotation initially displayed open.
    def opened=(opened : Bool)
      LibHaru.text_annot_set_opened(self, bool(opened))
    end
  end
end
