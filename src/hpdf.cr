require "./hpdf/*"

# `Hpdf` is a crystal wrapper of libharu.
#
# HARU is a free, cross platform, open-sourced software library for
# generating PDF. It supports the following features.
#
# * Generating PDF files with lines, text, images.
# * Outline, text annotation, link annotation.
# * Compressing document with deflate-decode.
# * Embedding PNG, Jpeg images.
# * Embedding Type1 font and TrueType font.
# * Creating encrypted PDF files.
# * Using various character set (ISO8859-1~16, MSCP1250~8, KOI-8R).
# * Supporting CJK fonts and encodings.
module Hpdf
  VERSION = "0.1.0"
end
