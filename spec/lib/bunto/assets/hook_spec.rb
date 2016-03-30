# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8

require "rspec/helper"

describe Bunto::Assets::Hook do
  before :each do
    Bunto::Assets::Hook::HOOK_POINTS.store(:test, [:test])
    Bunto::Assets::Hook.all.store(:test, {
      :test => { :early => Set.new, :late => Set.new }
    })
  end

  it "allows registration of receivers onto points" do
    hooks = Bunto::Assets::Hook.point(:test, :test, :late)
    Bunto::Assets::Hook.register(:test, :test, &proc {})
    expect(hooks.size).to eq 1
  end

  it "raises if there is no hook" do
    expect { Bunto::Assets::Hook.register(:unknown, :unknown, &proc {}) }.to \
      raise_error Bunto::Assets::Hook::UnknownHookError
  end

  it "raises if there is no hook point" do
    expect { Bunto::Assets::Hook.register(:env, :unknown, &proc {}) }.to \
      raise_error Bunto::Assets::Hook::UnknownHookError
  end

  it "sends a message to all receivers on a point" do
    result, tproc = 1, proc { result = 2 }
    Bunto::Assets::Hook.register(:test, :test, &tproc)
    Bunto::Assets::Hook. trigger(:test, :test)
    expect(result).to eq 2
  end
end
