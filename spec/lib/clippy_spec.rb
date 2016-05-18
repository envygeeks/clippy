require "rspec/helper"
shared_examples "Clippy" do
  it "can paste" do
    expect(Clippy.copy(str = SecureRandom.hex)).to eq true
    expect(Clippy.paste).to eq(
      str
    )
  end

  #

  it "can copy" do
    expect(Clippy.copy(str = SecureRandom.hex)).to eq true
    expect(get_clipboard_contents).to eq(
      str
    )
  end

  #

  it "can clear" do
    Clippy.copy(SecureRandom.hex)
    Clippy.clear

    expect(Clippy.paste).to(
      be_nil
    )
  end
end

#

describe "Clippy" do
  before do
    clear_binary
    Clippy.clear
    clear_binary
  end

  #

  it "sends clip for Windows" do
    allow(Clippy).to receive(:windows?).and_return true
    expect(Clippy.binary).to eq "clip"
  end

  #

  describe "#paste" do
    unless Clippy.windows?
      before do
        class Win32API
          def initialize(*args)
            nil
          end

          def call(*args)
            args
          end
        end
      end
    end

    #

    it "calls Win32API for Windows" do
      expect(Win32API).to receive(:new).exactly(3).times.and_call_original
      allow(Clippy).to receive(:windows?).and_return true
      Clippy.paste
    end
  end

  #

  context "with xclip" do
    it_behaves_like(
      "Clippy"
    )
  end

  #

  context "with xsel" do
    before do
      stub_binary(
        "xsel"
      )
    end

    #

    it_behaves_like(
      "Clippy"
    )
  end

  describe "#binary" do
    it "gives xclip preferably" do
      expect(Clippy.binary).to eq(
        "xclip"
      )
    end

    it "gives xsel" do
      expect(Clippy).to receive(:system).ordered.and_return false
      expect(Clippy).to receive(:system).ordered.and_return true
      expect(Clippy.binary).to eq(
        "xsel"
      )
    end

    it "gives pbcopy on Mac" do
      expect(Clippy).to receive(:system).twice.ordered.and_return false
      expect(Clippy).to receive(:system).and_return true
      expect(Clippy.binary).to eq(
        "pbcopy"
      )
    end
  end

  it "raises UnknownClipboardError if it can't find the binary" do
    allow(Clippy).to receive(:system).and_return false
    expect { Clippy.binary }.to raise_error(
      Clippy::UnknownClipboardError
    )
  end
end
