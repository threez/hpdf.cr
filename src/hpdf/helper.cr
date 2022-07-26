module Hpdf
  module Helper
    def real(val) : LibHaru::Real
      val.to_f32
    end

    def uint(val) : LibHaru::UInt
      val.to_u32
    end

    def uint16(val) : UInt16
      val.to_u16
    end
  end
end
