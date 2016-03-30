# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"

describe Bunto::Assets::Logger do
  before { Bunto.logger.log_level = :debug }
   after { Bunto.logger.log_level =  :info }
  let(:logger) { described_class.new }

  %W(warn error info debug).each do |v|
    it "allows blocks to be passed into the log method #{v}" do
      out = capture_stdout do
        logger.send(v) do
          v
        end
      end

      expect(strip_ansi(out.last.empty?? out.first : out.last).strip).to eq \
        "Bunto Assets: #{v}"
    end

    it "does not prevent standard strings on the method #{v}" do
      out = capture_stdout do
        logger.send(v, v.to_s)
      end

      expect(strip_ansi(out.last.empty?? out.first : out.last).strip).to eq \
        "Bunto Assets: #{v.to_s}"
    end
  end

  it "should raise if trying to set log level" do
    expect { logger.log_level = :debug }.to raise_error \
      RuntimeError
  end
end
