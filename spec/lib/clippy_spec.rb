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

  context "with xclip" do
    it_behaves_like "Clippy"
  end

  context "with xsel" do
    before(:each) { stub_binary("xsel") }
    it_behaves_like "Clippy"
  end

  it "raises UnknownClipboardError if it can't find the binary" do
    Clippy.stub(:system).and_return(false)
    expect { Clippy.binary }.to raise_error(Clippy::UnknownClipboardError)
  end
end
