require "./helper"

module Hpdf
  # The destination object specifies the view of the page to be displayed
  # when the outline item or annotation is clicked.
  # And the destination handle is used to operate destination object.
  class Destination
    include Helper

    def initialize(@destination : LibHaru::Destination, @doc : Doc)
    end

    def to_unsafe
      @font
    end
  end
end
