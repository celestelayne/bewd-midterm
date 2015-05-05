# Helper methods for recursively freezing objects
class Freezer
  # Completes a depth-first search of an object and its elements, running
  # a block on each element. If the block returns a value other than nil,
  # dfs() stops the search and returns the value. Otherwise, dfs() returns
  # nil at the end of the search.
  def self.dfs(o, &block)
    return block.call(o) unless o.is_a? Enumerable

    stack = [o]
    while stack.any?
      top = stack.pop
      result = block.call(top)
      return result unless result.nil?
      top.each { |el| stack << el } if top.is_a? Enumerable
    end
    nil
  end
  private_class_method :dfs

  # Freezes an object. If the object is an Enumerable, recursively freezes
  # its elements.
  def self.freeze(o)
    dfs o do |el|
      el.freeze
      nil
    end
    o
  end

  # Checks the frozen state of an object, recursively checking its elements
  # (if it is an Enumerable), returning true if the object and its elements are
  # frozen and false if not.
  def self.frozen?(o)
    dfs(o) { |el| el.frozen? ? nil : false }.nil?
  end

  # Clones an object, then runs Freezer.freeze on the clone.
  # If the object is already "recursively immutable," returns the object without
  # cloning it.
  def self.clone(o)
    frozen?(o) ? o : freeze(o.clone)
  end
end
