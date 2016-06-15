# encoding: utf-8
require 'spec_helper'
require "logstash/filters/ands"

describe LogStash::Filters::ANDS do

  #todo custom timestamp


  describe "Portal Page View" do
    let(:config) do <<-CONFIG
      filter {
        ANDS {
          message => "[date:2016-06-15 11:29:29] [event:portal_page][page:home][ip:67.225.218.51][user_agent:Mozilla/4.0 (compatible; MSIE 6.0; www.uptimedoctor.com username tran.le@ands.org.au)]"
        }
      }
    CONFIG
    end

    sample("Verify all fields are there") do
      expect(subject.get("processed")).to eq("false")
      expect(subject.get("date")).to eq("2016-06-15 11:29:29")
      expect(subject.get("event")).to eq("portal_page")
      expect(subject.get("page")).to eq("home")
      expect(subject.get("ip")).to eq("67.225.218.51")
      expect(subject.get("user_agent")).to eq("Mozilla/4.0 (compatible; MSIE 6.0; www.uptimedoctor.com username tran.le@ands.org.au)")
    end

    sample("Verify custom timestamp is set") do
      expect(subject.get("@timestamp").to_s).to eq("2016-06-15T01:29:29.000Z")
    end

  end

  describe "Portal Record View" do
    let(:config) do <<-CONFIG
      filter {
        ANDS {
          message => "[date:2016-04-30 23:59:57] [event:portal_view][roid:633621][roclass:collection][dsid:196][group:data.vic.gov.au][ip:66.249.79.93][user_agent:Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)][source:suggested_datasets]"
        }
      }
    CONFIG
    end

    sample "Verify custom timestamp" do
      expect(subject.get("@timestamp").to_s).to eq("2016-04-30T13:59:57.000Z")
    end

    sample "Verify custom fields" do
      expect(subject.get("roid")).to eq("633621")
      expect(subject.get("roclass")).to eq("collection")
      expect(subject.get("dsid")).to eq("196")
      expect(subject.get("group")).to eq("data.vic.gov.au")
      expect(subject.get("ip")).to eq("66.249.79.93")
      expect(subject.get("source")).to eq("suggested_datasets")
    end

  end
end
