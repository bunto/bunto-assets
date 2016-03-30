# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Kernel do
  context "#try_require" do
    it "does not raise when the file doesn't exist" do
      result = try_require("if_this_exists_we_are_screwed") { "hello" }
      expect(result).to be_nil
    end

    it "runs your code if the file exists" do
      result = try_require("bunto/assets") { "hello" }
      expect(result).to eq "hello"
    end
  end

  context "#try_require_if_javascript" do
    it "runs your code if both JavaScript and the file exists" do
      result = try_require_if_javascript("bunto/assets") { "hello" }
      expect(result).to eq "hello"
    end

    it "does not run your code if JavaScript does not exist" do
      allow(self).to receive(:require).and_raise ExecJS::RuntimeUnavailable
      result = try_require_if_javascript("bunto/assets") { "hello" }
      expect(result).to be_nil
    end

    it "does not run or pass the error if the file does not exist" do
      allow(self).to receive(:require).and_raise LoadError
      result = try_require_if_javascript("bunto/assets") { "hello" }
      expect(result).to be_nil
    end
  end
end
