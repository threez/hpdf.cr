# hpdf (**WIP**)

Shard to create PDF documents with crystal using [libharu/libhpdf](https://github.com/libharu/libharu/).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     hpdf:
       github: threez/hpdf.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "hpdf"

pdf = Hpdf::Doc.new
page = pdf.add_page

page.draw_rectangle(50, 50, page.width - 100, page.height - 110)

page.text "Helvetica", 70 do
  page.text_out(:center, :center, "Hello World")
end

pdf.save_to_file("hello.pdf")
```

Before usage you have to install the libraries:

### Debian/Ubuntu

```shell
sudo apt install libhpdf-dev
```

## Development

Use the examples to write demos. Read about *libharu* here:

* http://libharu.sourceforge.net/index.html
* https://github.com/libharu/libharu/wiki

## Contributing

1. Fork it (<https://github.com/your-github-user/hpdf/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Vincent Landgraf](https://github.com/your-github-user) - creator and maintainer
