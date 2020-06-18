class << RSpec::OpenAPI::SchemaMerger = Object.new
  # @param [Hash] base
  # @param [Hash] spec
  def reverse_merge!(base, spec)
    spec = normalize_keys(spec)
    deep_reverse_merge!(base, spec)
  end

  private

  def normalize_keys(spec)
    if spec.is_a?(Hash)
      spec.map do |key, value|
        [key.to_s, normalize_keys(value)]
      end.to_h
    else
      spec
    end
  end

  # Not doing `base.replace(deep_merge(base, spec))` to preserve key orders
  # TODO: Perform more intelligent merges like rerouting edits / merging types
  # Should we probably force-merge `summary` regardless of manual modifications?
  def deep_reverse_merge!(base, spec)
    spec.each do |key, value|
      if base[key].is_a?(Hash) && value.is_a?(Hash)
        deep_reverse_merge!(base[key], value)
      elsif !base.key?(key)
        base[key] = value
      end
    end
    base
  end
end
