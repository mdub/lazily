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
    def associate(enumerable_map)
      labelled_enumerables = enumerable_map.map do |label, enumerable|
        enumerable.lazily.map { |e| [e, e, label] }
      end
      labelled_elements = Lazily.merge(*labelled_enumerables) { |triple| triple.first }
      labelled_elements.chunk { |triple| triple.first }.map do |key, triples|
        create_association.tap do |association|
          triples.each do |triple|
            association[triple.last] << triple.first
          end
        end
      end
    end

    private

    def create_association
      Hash.new do |hash, key|
        hash[key] = []
      end
    end

  end

end
