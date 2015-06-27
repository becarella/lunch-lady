class Hash
  def whitelist allowed_keys
    allowed_keys = [allowed_keys].flatten
    allowed_keys = allowed_keys.map{|v| v.to_sym}
    self.symbolize_keys.select { |key, value| allowed_keys.include?(key) }
  end
end
