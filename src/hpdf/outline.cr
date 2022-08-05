require "./helper"

module Hpdf
  # The outline handle is used to operate an outline of a document.
  class Outline
    include Helper

    def initialize(@outline : LibHaru::Outline, @doc : Doc)
    end

    def to_unsafe
      @outline
    end

    # sets whether this node is opened or not when the outline
    # is displayed for the first time.
    #
    # * *opened* specify whether the node is opened or not.
    def opened=(v : Bool)
      LibHaru.outline_set_opened(self, bool(v))
    end

    # sets a destination object which becomes to a target to jump
    # when the outline is clicked.
    #
    # * *dst* specify the handle of an destination object.
    def destination=(dst : Destination)
      LibHaru.outline_set_destination(self, dst)
    end
  end
end
