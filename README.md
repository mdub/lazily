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

    # enumerate all users
    users = User.to_enum(:find_each)

    # be lazy
    users = users.lazily

    # where first and last names start with the same letter
    users = users.select { |u| u.first_name[0] == u.last_name[0] }

    # grab their company (weeding out duplicates)
    companies = users.collect(&:company).uniq

    # resolve
    companies.to_a              #=> ["Disney"]

Because the steps in the pipeline operate in parallel, without creation of intermediate collections (Arrays), you can efficiently operate on large (or even infinite) Enumerable collections.

This is analogous to a Unix shell pipeline, though of course here we're talking about streams of objects, rather than streams of text.

Lazy multi-threaded processing
------------------------------

The `#in_threads` method is a multi-threaded version of `#collect`, allowing multiple elements of a collection to be processed in parallel.  It requires a numeric argument specifying the maximum number of Threads to use. 

    start = Time.now
    [5,6,7,8].lazily.in_threads(4) do |delay|
      sleep(delay)
    end.to_a
    (Time.now - start).to_i     #=> 8

Outputs will be yielded in the expected order, making it a drop-in replacement for `#collect`. 

Unlike some other "parallel map" implementations, the output of `#in_threads` is lazy (though it does need to pre-fetch elements from the source collection as required to start Threads).

Lazy combination of Enumerables
-------------------------------

Lazily also provides some interesting ways to combine several Enumerable collections to create a new collection.

`Lazily.zip` pulls elements from a number of collections in parallel, yielding each group.

    array1 = [1,3,6]
    array2 = [2,4,7]
    Lazily.zip(array1, array2)             #=> [1,2], [3,4], [6,7]

`Lazily.concat` concatenates collections.

    array1 = [1,3,6]
    array2 = [2,4,7]
    Lazily.concat(array1, array2)
                                           #=> [1,3,6,2,4,7]

`Lazily.merging` merges multiple collections, preserving sort-order.  The inputs are assumed to be sorted already.

    array1 = [1,4,5]
    array2 = [2,3,6]
    Lazily.merging(array1, array2)          #=> [1,2,3,4,5,6]

Variant `Lazily.merging_by` uses a block to determine sort-order.

    array1 = %w(a dd cccc)
    array2 = %w(eee bbbbb)
    Enumerating.merging_by(array1, array2) { |x| x.length }
                                            #=> %w(a dd eee cccc bbbbb)

Same but different
------------------

There are numerous similar implementations of lazy operations on Enumerables.  

### Lazily vs. Enumerating

Lazily supercedes "[Enumerating](http://github.com/mdub/enumerating)".  Whereas Enumerating mixing lazy operations directly into `Enumerable`, Lazily does not.  Instead, it implements an API modelled on Ruby 2.0's `Enumerable#lazy`.

### Lazily vs. Ruby 2.0

FAQ: Why would you use Lazily, when Ruby now has built-in lazy enumeration?

- Compatibility: Perhaps you haven't managed to migrate to Ruby 2.0 yet.  Lazily provides the same benefits, but works in older versions of Ruby (most features work even in Ruby-1.8.7).
- Features: Lazily provides some extra features not present in Ruby 2.0, such as multi-threaded lazy enumeration.
- Speed: Despite being implemented in pure Ruby, `Enumerable#lazily` actually performs a little better than `Enumerable#lazy`.

### Others

See also:

* Greg Spurrier's gem "`lazing`"
* `Enumerable#defer` from the Ruby Facets library
* The "`backports`" gem, which implements `Enumerable#lazy` for Ruby pre-2.0.
