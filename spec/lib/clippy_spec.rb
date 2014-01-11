require "rspec/helper"

shared_examples "Clippy" do
  it "can paste" do
    expect(Clippy.copy(str = SecureRandom.hex)).to be_true
    expect(Clippy.paste).to eq str
  end

  it "can copy" do
    expect(Clippy.copy(str = SecureRandom.hex)).to be_true
    expect(get_clipboard_contents).to eq str
  end

  it "can clear" do
    Clippy.copy(SecureRandom.hex)
    Clippy.clear
    expect(Clippy.paste).to be_nil
  end
end

describe "Clippy" do
  before :each do
    clear_binary
    Clippy.clear
    clear_binary
  end

  it "sends clip for Windows" do
    Clippy.stub(:windows?).and_return(true)
    expect(Clippy.binary).to eq "clip"
  end

  describe "#paste" do
    before :each do
      unless Clippy.windows?
        class Win32API
          def initialize(*args)
            # Mocked
          end

          def call(*args)
            args
          end
        end
      end
    end

    after :each do
      unless Clippy.windows?
        Object.send(:const_remove, Win32API)
      end
    end

    it "calls Win32API for Windows" do
      Win32API.should_receive(:new).exactly(3).times.and_call_original
      Clippy.stub(:windows?).and_return(true)
      Clippy.paste
    end
  end

  context "with xclip" do
    it_behaves_like "Clippy"
  end

  context "with xsel" do
    before(:each) { stub_binary("xsel") }
    it_behaves_like "Clippy"
  end

  describe "#binary" do
    it "gives xclip preferably" do
      expect(Clippy.binary).to eq "xclip"
    end

    it "gives xsel" do
      Clippy.should_receive(:system).ordered.and_return(false)
      Clippy.should_receive(:system).ordered.and_return(true)
      expect(Clippy.binary).to eq "xsel"
    end

    it "gives pbcopy on Mac" do
      Clippy.should_receive(:system).twice.ordered.and_return(false)
      Clippy.should_receive(:system).and_return(true)
      expect(Clippy.binary).to eq "pbcopy"
    end
  end

  it "raises UnknownClipboardError if it can't find the binary" do
    Clippy.stub(:system).and_return(false)
    expect { Clippy.binary }.to raise_error(Clippy::UnknownClipboardError)
  end
end
