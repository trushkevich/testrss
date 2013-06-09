require 'net/http'
require 'feedzirra'

class FeedValidator < UrlValidator

  # record should have an :xml attribute where it is possible to store feed's XML
  #
  def validate_each(record, attribute, value)
    super

    unless record.errors.messages[attribute]
      value = 'http://' + value unless value =~ /\Ahttps?:\/\/.*/
      # handle exceptions in case if url validation regex missed anything
      begin
        url = URI.parse(value)
      rescue URI::InvalidURIError => e
        record.errors.add attribute.to_s.gsub('_',' '), 'is an invalid URI'
      else
        request = Net::HTTP.new(url.host, url.port)
        response = request.request_get(url.path)

        if response.code.to_i != 200
          record.errors.add attribute.to_s.gsub('_',' '), 'responds with status other than 200 OK'
        else
          begin
            feed = Feedzirra::Feed.parse(response.body)
          rescue Feedzirra::NoParserAvailable
            record.errors.add attribute.to_s.gsub('_',' '), 'is not a valid RSS or Atom feed'
          else
            # if attribute is valid RSS or Atom feed then we store xml in database at the moment
            # in order not to send another unnecessary feed server request, and also set record
            # name in order not to make additional db request, and also normalize attribute in order 
            # not to create to different channels for www and http://www
            record.xml = response.body
            record.name = feed.title
            record.url = value
          end
        end
      end
    end
  end

end
