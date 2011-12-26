Given 'Clippy exist and it has a version.' do
  should be_defined Clippy
  should be_defined Clippy.version
end

Then 'Copy, Paste and Clear should exist.' do
  [:copy, :paste, :clear].each do |service|
    true.should == Clippy.respond_to?(service)
  end
end
