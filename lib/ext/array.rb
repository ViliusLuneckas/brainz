class Array
  def to_hash(keys)
    hash = {}
    keys.zip(self).each { |k, v| hash[k] = v }
    hash
  end
end
