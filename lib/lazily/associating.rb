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
    def associate(enumerable_map, &distinctor)
      labels = enumerable_map.keys
      labelled_enumerables = enumerable_map.map do |label, enumerable|
        enumerable.lazily.map do |e|
          key = distinctor ? distinctor.call(e) : e
          [key, e, label]
        end
      end
      labelled_elements = Lazily.merge(*labelled_enumerables) { |triple| triple.first }
      labelled_elements.chunk { |triple| triple.first }.map do |key, triples|
        association = {}
        labels.each { |label| association[label] = [] }
        triples.each do |triple|
          association[triple.last] << triple[1]
        end
        association
      end
    end

  end

end
