class Hash
  def no_underscore
    select do |name|
      if name.is_a?(Symbol) || name.is_a?(String)
        !name.to_s.starts_with? '_'
      else
        true
      end
    end
  end
end