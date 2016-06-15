# encoding: utf-8
require 'spec_helper'
require "logstash/filters/ands"

describe LogStash::Filters::ANDS do
  describe "Set processed to false" do
    let(:config) do <<-CONFIG
      filter {
        ANDS {
          message => "[date:2016-06-15 11:29:29] [event:portal_page][page:home][ip:67.225.218.51][user_agent:Mozilla/4.0 (compatible; MSIE 6.0; www.uptimedoctor.com username tran.le@ands.org.au)]"
        }
      }
    CONFIG
    end

    sample("message" => "[date:2016-06-15 11:29:29] [event:portal_page][page:home][ip:67.225.218.51][user_agent:Mozilla/4.0 (compatible; MSIE 6.0; www.uptimedoctor.com username tran.le@ands.org.au)]") do
      expect(subject.get("processed")).to eq('false')
    end

  end
end
