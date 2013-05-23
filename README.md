Lazily [![Build Status](https://secure.travis-ci.org/mdub/lazily.png?branch=master)](http://travis-ci.org/mdub/lazily)
===========

Lazily provides various "lazy" Enumerable operations, similar to:

* Clojure's sequences
* Haskell's lists
* Scala's "views"
* Ruby 2.0's Enumerator::Lazy

Lazy filtering and transforming
-------------------------------

Lazy evaluation is triggered using `Enumerable#lazily`:

    [1,2,3].lazily              #=> #<Lazily::Proxy: [1, 2, 3]>

The resulting object implements lazy versions of various Enumerable methods.  Rather than returning Arrays, the lazy forms return new Enumerable objects, which generate results incrementally, on demand.

Consider the following code, which squares a bunch of numbers, then takes the first 4 results.

    >> (1..10).collect { |x| p x; x*x }.take(4)
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    => [1, 4, 9, 16]

See how it printed all the numbers from 1 to 10, indicating that the block given to `collect` was run ten times. We can do the same thing lazily, like this:

    >> (1..10).lazily.collect { |x| p x; x*x }.take(4).to_a
    1
    2
    3
    4
    => [1, 4, 9, 16]

Same result, but notice how the block was only evaluated four times. 

Lazy pipelines
--------------

By combining two or more lazy operations, you can create an efficient "pipeline", e.g.

    User.to_enum(:find_each).lazily.select do |u| 
      u.first_name[0] == u.last_name[0]
    end.collect(&:company).uniq.to_a

In case you missed it:

    # enumerate all users
    users = User.to_enum(:find_each)

    # lazily select those matching "X... X..." (e.g. "Mickey Mouse")
    users = users.lazily.select { |u| u.first_name[0] == u.last_name[0] }

    # grab their company (weeding out duplicates)
    companies = users.collect(&:company).uniq

    # force resolution
    companies.to_a              #=> ["Disney"]

Because the steps in the pipeline operate in parallel, without creation of intermediate collections (Arrays), you can efficiently operate on large (or even infinite) Enumerable collections.

This is analogous to a Unix shell pipeline, though of course here we're talking about streams of objects, rather than streams of text.

Lazy multi-threaded processing
------------------------------

The `#in_threads` method is a multi-threaded version of `#collect`, allowing multiple elements of a collection to be processed in parallel.  It requires a numeric argument specifying the maximum number of Threads to use. 

    Benchmark.realtime do
      [1,2,3,4].lazily.in_threads(10) do |x|
        sleep 1
        x * 2
      end.to_a                  #=> [2,4,6,8]
    end.to_i                    #=> 1

Outputs will be yielded in the expected order, making it a drop-in replacement for `#collect`. 

Unlike some other "parallel map" implementations, the output of `#in_threads` is lazy (though it does need to pre-fetch elements from the source collection as required to start Threads).

Lazy combination of Enumerables
-------------------------------

Lazily also provides some interesting ways to combine several Enumerable collections to create a new collection.

`Lazily.zip` pulls elements from a number of collections in parallel, yielding each group.

    array1 = [1,3,6]
    array2 = [2,4,7]
    Lazily.zip(array1, array2)          #=> [1,2], [3,4], [6,7]

`Lazily.concat` concatenates collections.

    array1 = [1,3,6]
    array2 = [2,4,7]
    Lazily.concat(array1, array2)       #=> [1,3,6,2,4,7]

`Lazily.merge` merges multiple collections, preserving sort-order.  The inputs are assumed to be sorted already.

    array1 = [1,4,5]
    array2 = [2,3,6]
    Lazily.merge(array1, array2)        #=> [1,2,3,4,5,6]

A block can be provided to determine the sort-order.

    array1 = %w(a dd cccc)
    array2 = %w(eee bbbbb)
    Lazily.merge(array1, array2) { |x| x.length }
                                        #=> %w(a dd eee cccc bbbbb)

Same but different
------------------

There are numerous similar implementations of lazy operations on Enumerables.  

### Lazily vs. Enumerating

Lazily supercedes "[Enumerating](http://github.com/mdub/enumerating)".  Whereas Enumerating mixed lazy operations directly onto `Enumerable`, Lazily does not.  Instead, it implements an API modelled on Ruby 2.0's `Enumerable#lazy`.

### Lazily vs. Ruby 2.0

Q: Why use Lazily, when Ruby 2.x has built-in lazy enumerations?

- Compatibility: Perhaps you haven't managed to migrate to Ruby 2.0 yet.  Lazily provides the same benefits, but works in older versions of Ruby (most features work even in Ruby-1.8.7).
- Consistency: Being pure-Ruby, you can use the same implementation of lazy enumeration across Ruby versions and interpreters.
- Features: Lazily provides some extra features not present in Ruby 2.0, such as multi-threaded lazy enumeration.
- Speed: Despite being implemented in pure Ruby, `Enumerable#lazily` actually performs a little better than `Enumerable#lazy`.

### Others

See also:

* Greg Spurrier's gem "`lazing`"
* `Enumerable#defer` from the Ruby Facets library
* The "`backports`" gem, which implements `Enumerable#lazy` for Ruby pre-2.0.
