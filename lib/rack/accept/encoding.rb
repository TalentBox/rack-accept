module Rack::Accept

  # Represents an HTTP Accept-Encoding header according to the HTTP 1.1
  # specification, and provides several convenience methods for determining
  # acceptable content encodings.
  #
  # See http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html for more
  # information.
  class Encoding

    include Header

    # The name of this header.
    def name
      'Accept-Encoding'
    end

    # Determines the quality factor (qvalue) of the given +encoding+,
    # according to the specifications of the original header.
    def qvalue(encoding)
      m = matches(encoding)
      if m.empty?
        encoding == 'identity' ? 1 : 0
      else
        @qvalues[m.first]
      end
    end

    # Returns an array of encodings from the original header that match
    # the given +encoding+, ordered by precedence.
    def matches(encoding)
      values.select {|v|
        v == encoding || v == '*'
      }.sort {|a, b|
        # "*" gets least precedence, any others should be equal.
        a == '*' ? 1 : (b == '*' ? -1 : 0)
      }
    end

  end
end