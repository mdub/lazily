require "lazily/enumerable"

module Lazily

  class << self

    # Associate "like" elements of two or more Enumerables.
    #
    # @param labelled_enumerables [Hash<key,Enumerable>]
    # @return [Enumerable] a lazy collection of Hashes
    #
    # @example
    #   Lazily.associate(a: [1,2,4], b: [1,3,4,4])
    #     #=> [
    #       { a: [1], b: [1] },
    #       { a: [2] },
    #       { b: [3] },
    #       { a: [4], b: [4, 4] }
    #     ]
    #
    def associate(source_map, &block)
      labels = source_map.keys
      tagged_element_sources = source_map.map do |label, enumerable|
        enumerable.lazily.map do |value|
          key = block ? block.call(value) : value
          TaggedElement.new(key, value, label)
        end
      end
      tagged_elements = Lazily.merge(*tagged_element_sources) { |te| te.key }
      tagged_elements.chunk { |te| te.key }.map do |_, tagged_elements|
        association = {}
        labels.each { |label| association[label] = [] }
        tagged_elements.each do |te|
          association[te.label] << te.value
        end
        association
      end
    end

    TaggedElement = Struct.new(:key, :value, :label)

  end

end
