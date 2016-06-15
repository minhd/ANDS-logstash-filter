# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# This example filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an example.
class LogStash::Filters::ANDS < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   ANDS {
  #     message => "My message..."
  #   }
  # }
  #
  config_name "ANDS"

  # Replace the message with this value.
  config :message, :validate => :string


  public
  def register
    # Add instance variables
  end # def register

  public
  def filter(event)

    if @message
      # Replace the event message with our message as configured in the
      # config file.

      # using the event.set API
      event.set("message", @message)
      event.set("processed", "false")

      for tuple in @message.split(/\[([^\]]*)\]/)
        result = tuple.split(':')

        key = result[0]
        if key
          result.shift()
          value = result.join(":")
          event.set(key, value)
          if key == "date"
            puts value
            puts Date.iso8601(value)
            puts event.get('@timestamp')
            # event.set("@timestamp", Time.at(value).strftime('%Y-%m-%d %H:%M:%S'))
          end
        end

      end

      print event

      # correct debugging log statement for reference
      # using the event.get API
      @logger.debug? && @logger.debug("Message is now: #{event.get("message")}")
    end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::ANDS
