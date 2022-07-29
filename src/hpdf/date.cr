module Hpdf
  # Date that can be used with "Doc#creation_date=" and "Doc#mod_date="
  struct Date
    # Create a date based on the passed time
    def initialize(time : Time)
      @date = LibHaru::Date.new
      @date.year = time.year
      @date.month = time.month
      @date.day = time.day
      @date.hour = time.hour
      @date.minutes = time.minute
      @date.seconds = time.second
      if time.offset != 0
        @date.ind = time.offset < 0 ? '-' : '+'
        @date.off_hour = (time.offset // 3600).abs
        @date.off_minutes = (time.offset % 3600).abs
      else
        @date.ind = ' '
      end
    end

    FORMAT = /D:(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(([+-])(\d{2})'(\d{2})')?/

    # parses the pdf time format e.g. `"D:20220729135612+02'00'"`
    def self.parse(time_str : String) : Time
      md = FORMAT.match(time_str)
      raise Exception.new("invalid date: #{time_str.inspect}") unless md

      year = md[1].to_i
      month = md[2].to_i
      day = md[3].to_i
      hour = md[4].to_i
      minute = md[5].to_i
      second = md[6].to_i

      # default utc
      location = Time::Location::UTC

      if md[7]? # has offset
        offset_indicator = md[8]
        offset_hour = md[9].to_i
        offset_minute = md[10].to_i
        offset = (offset_hour * 60 + offset_minute) * 60
        location = Time::Location.fixed offset_indicator == "-" ? offset * -1 : offset
      end

      Time.local year, month, day,
                 hour, minute, second, location: location
    end

    def to_unsafe
      @date
    end
  end
end
