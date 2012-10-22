class Object
  ##
  # ---
  # Hood jacked from Rails.
  ##

  def blank?
    (respond_to?(:empty?)) ? (empty?) : (!self)
  end
end
