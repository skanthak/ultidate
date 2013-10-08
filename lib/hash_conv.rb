require 'iconv'

class Hash
    # Convert all string values in this hash from one character encoding
    # into another, using iconv.
    # This conversion will be applied recursively to nested hashes.
    def iconv!(to,from)
        iconv = Iconv.new(to,from)
        perform_iconv!(iconv)
        iconv.close
    end

    # Convert all string values in this hash using the Iconv object
    # iconv.
    # This conversion will be applied recursively to nested hashes.    
    def perform_iconv!(iconv)
        each_pair do |key,value|
            case value
                when String
                    self[key] = iconv.iconv(value)
                when Hash
                    value.perform_iconv!(iconv)
            end
        end
    end
end
