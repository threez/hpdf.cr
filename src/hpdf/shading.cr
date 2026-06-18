module Hpdf
  # A shading object defines a smooth colour gradient using a Gouraud-shaded
  # triangle mesh. Create one with `Doc#create_shading`, add vertices with
  # `#add_vertex`, then paint it onto a page with `Page#set_shading`.
  #
  # Each group of three `NoConnection` vertices forms one triangle. Additional
  # triangles can share an edge with the previous one via `PreviousBC` /
  # `PreviousAC` edge flags, building a connected mesh.
  #
  # Currently only `ShadingType::FreeFormTriangleMesh` (type 4) is supported
  # by libharu.
  #
  # ```
  # sh = doc.create_shading(Hpdf::ShadingType::FreeFormTriangleMesh,
  #   Hpdf::ColorSpace::DeviceRgb, 0, 400, 0, 500)
  # sh.add_vertex(edge: :no_connection, x: 0, y: 0, r: 255_u8, g: 0_u8, b: 0_u8)
  # sh.add_vertex(edge: :no_connection, x: 400, y: 0, r: 0_u8, g: 255_u8, b: 0_u8)
  # sh.add_vertex(edge: :no_connection, x: 200, y: 500, r: 0_u8, g: 0_u8, b: 255_u8)
  # page.set_shading(sh)
  # ```
  class Shading
    include Helper

    def initialize(@shading : LibHaru::Shading, @doc : Doc)
    end

    def to_unsafe
      @shading
    end

    # adds a vertex to the shading mesh.
    #
    # * *edge* connectivity to the previous triangle — accepts a `ShadingEdgeFlag`
    #   or one of the symbols `:no_connection`, `:previous_bc`, `:previous_ac`
    # * *x*, *y* coordinates of the vertex in user space
    # * *r*, *g*, *b* RGB colour components of the vertex (0–255 each)
    def add_vertex(*, edge : ShadingEdgeFlag | Symbol, x : Number, y : Number,
                   r : UInt8, g : UInt8, b : UInt8)
      flag = case edge
             when ShadingEdgeFlag
               edge
             when :no_connection
               ShadingEdgeFlag::NoConnection
             when :previous_bc
               ShadingEdgeFlag::PreviousBC
             when :previous_ac
               ShadingEdgeFlag::PreviousAC
             else
               raise ArgumentError.new("unknown edge flag: #{edge}")
             end
      LibHaru.shading_add_vertex_rgb(self, flag.to_u32, real(x), real(y), r, g, b)
    end
  end
end
