if Gem::Specification.find_all_by_name('simplecov').any?
  unless %W(no false).include?(ENV['COVERAGE'])
    unless Gem::Specification.find_all_by_name('envygeeks-coveralls').empty?
      require 'envygeeks/coveralls'
    end

    SimpleCov.start do
      add_filter '/spec'
      add_filter '/vendor'
    end
  end
end
