class ImageUtil
  
  # credits: http://snippets.dzone.com/posts/show/805
  def self.dimensions(file)
    case file
    when /\.png$/i
      IO.read(file)[0x10..0x18].unpack('NN')
    when /\.jpg$/i
      File.open(file, 'rb') do |io|
        raise 'malformed JPEG' unless io.getc == 0xFF && io.getc == 0xD8 # SOI

        class << io
          def readint; (readchar << 8) + readchar; end
          def readframe; read(readint - 2); end
          def readsof; [readint, readchar, readint, readint, readchar]; end
          def next
            c = readchar while c != 0xFF
            c = readchar while c == 0xFF
            c
          end
        end

        while marker = io.next
          case marker
            when 0xC0..0xC3, 0xC5..0xC7, 0xC9..0xCB, 0xCD..0xCF # SOF markers
              length, bits, height, width, components = io.readsof
              raise 'malformed JPEG' unless length == 8 + components * 3
            when 0xD9, 0xDA:  break # EOI, SOS
            when 0xFE:        @comment = io.readframe # COM
            when 0xE1:        io.readframe # APP1, contains EXIF tag
            else              io.readframe # ignore frame
          end
        end
        [width, height]
      end
    when /\.bmp$/i
      d = IO.read(file)[14..28]
      d[0] == 40 ? d[4..-1].unpack('LL') : d[4..8].unpack('SS')
    when /\.gif$/i
      IO.read(file)[6..10].unpack('SS')
    else
      raise "Unsupported image type or 'wrong' file name suffix :/"
    end
  end
end