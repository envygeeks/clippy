class Clippy
  class << self
    def clear
      if copy("")
        return true
      end
    end
  end
end
