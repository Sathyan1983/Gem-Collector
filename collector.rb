module Collector

  def self.included(base)
    base.extend(ClassMethods)
    base.instance_variable_set(:@collections, { })
  end

  def my_class
    self.class
  end

  def initialize_all
    my_class.collections[:all] = { }
  end

  def collections_check
    initialize_all if no_collections?
    consider_all
    my_class.collections[:all][object_id] = self
  end

  def no_collections?
    my_class.collections.empty?
  end

  def consider_all
    instance_variables.each { |variable| consider(variable) }
  end

  def consider(variable)
    my_class.collections.has_key?(variable) ? check_value(variable) : make_collection(variable)
  end

  def make_collection(variable)
    my_class.collections[variable] = { }
    check_value(variable)
  end

  def check_value(variable)
    value = instance_variable_get(variable)
    value_key = keyify(value)
    if my_class.collections[variable].has_key?(value.to_s)
      my_class.collections[variable][value_key][object_id] = self
    else
      my_class.collections[variable][value_key] = { }
      my_class.collections[variable][value_key][object_id] = self
    end
  end

  def keyify(value)
    value.to_s.to_sym
  end

  module ClassMethods
    attr_reader :collections
  end

end
