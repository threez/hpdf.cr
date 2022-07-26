module Hpdf
  module Helper
    def real(val) : LibHaru::Real
      val.to_f32
    end
  end
end
