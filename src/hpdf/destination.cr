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
      @destination
    end

    # defines the appearance of a page with three parameters which
    # are left, top and zoom.
    #
    # * *left* the left coordinates of the page.
    # * *top* the top coordinates of the page.
    # * *zoom* the page magnified factor. The value must be between 0.08(8%) to 32(%).
    def xyz!(left : Number, top : Number, zoom : Number)
      LibHaru.destination_set_xyz(self, left, top, zoom)
    end

    # sets the appearance of the page to displaying entire
    # page within the window.
    def fit!
      LibHaru.destination_set_fit(self)
    end

    # defines the appearance of a page to magnifying to fit the width
    # of the page within the window and setting the top position of the
    # page to the value of the "top" parameter.
    #
    # * *top* the top coordinates of the page.
    def fit_h!(top : Number)
      LibHaru.destination_set_fit_h(self, real(top))
    end

    # defines the appearance of a page to magnifying to fit the height
    # of the page within the window and setting the left position of
    # the page to the value of the "left" parameter.
    #
    # * *left* the left coordinates of the page.
    def fit_v!(left : Number)
      LibHaru.destination_set_fit_v(self, real(top))
    end

    # defines the appearance of a page to magnifying the page to fit a
    # rectangle specified by left, bottom, right and top.
    #
    # * *left* the left coordinates of the page.
    # * *bottom* the bottom coordinates of the page.
    # * *right* the right coordinates of the page.
    # * *top* the top coordinates of the page.
    def fit_r!(left : Number, bottom : Number, right : Number, top : Number)
      LibHaru.destination_set_fit_r(self, real(left), real(bottom), real(right), real(top))
    end

    # sets the appearance of the page to magnifying to fit
    # the bounding box of the page within the window.
    def fit_b!
      LibHaru.destination_set_fit_b(self)
    end

    # defines the appearance of a page to magnifying to fit the width
    # of the page within the window and setting the top position of the
    # page to the value of the "top" parameter.
    #
    # * *left* the top coordinates of the page.
    def fit_bh!(left : Number)
      LibHaru.destination_set_fit_bh(self, real(left))
    end

    # defines the appearance of a page to magnifying to fit the height of
    # the bounding box of the page within the window and setting the
    # top position of the page to the value of the "top" parameter.
    #
    # * *top* the top coordinates of the page.
    def fit_bv!(top : Number)
      LibHaru.destination_set_fit_bh(self, real(top))
    end
  end
end
