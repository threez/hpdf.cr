module Hpdf
  module Helper
    def real(val : Number) : LibHaru::Real
      val.to_f32
    end

    def uint(val : Number) : LibHaru::UInt
      raise ArgumentError.new("invalid number, has to be >= 0") if val < 0
      val.to_u32
    end

    def uint16(val : Number) : UInt16
      raise ArgumentError.new("invalid number, has to be >= 0") if val < 0
      val.to_u16
    end

    def bool(val : Bool) : Int32
      val ? 1 : 0
    end

    def nilable_str(v : Pointer(UInt8)) : String?
      String.new(v) unless v.null?
    end
  end
end
