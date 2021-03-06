##
# Range
#
# ISO 15.2.14
class Range

  ##
  # Calls the given block for each element of +self+
  # and pass the respective element.
  #
  # ISO 15.2.14.4.4
  def each(&block)
    return to_enum :each unless block_given?

    val = self.first
    last = self.last

    if val.kind_of?(Fixnum) && last.kind_of?(Fixnum) # fixnums are special
      lim = last
      lim += 1 unless exclude_end?
      i = val
      while i < lim
        block.call(i)
        i += 1
      end
      return self
    end

    unless val.respond_to? :succ
      raise TypeError, "can't iterate"
    end

    return self if (val <=> last) > 0

    while (val <=> last) < 0
      block.call(val)
      val = val.succ
    end

    if not exclude_end? and (val <=> last) == 0
      block.call(val)
    end
    self
  end

  # redefine #hash 15.3.1.3.15
  def hash
    h = first.hash ^ last.hash
    if self.exclude_end?
      h += 1
    end
    h
  end
end

##
# Range is enumerable
#
# ISO 15.2.14.3
class Range
  include Enumerable
end
