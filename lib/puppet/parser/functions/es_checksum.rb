module Puppet::Parser::Functions
  newfunction(:es_checksum, :type => :rvalue, :doc => <<-EOS
This function returns the checksum from elastic search checksum file.
*Examples:*
    es_checksum('https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.5.deb.sha1.txt')
Would return: "b51e4dc55490bc03e54d7f8f2d41affc54773206"
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "es_checksum(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size != 1

    begin
      require 'open-uri'
      result = open(arguments[0]).read
      result.split.first
    rescue Exception => e
      Puppet.debug("Unable to obtain elastic search checksum: #{e.message}")
      nil
    end
  end
end
