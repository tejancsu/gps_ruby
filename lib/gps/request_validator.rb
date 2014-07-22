module Gps::RequestValidator

  class PropertyNotSetError < StandardError; end

  class Property
    attr_accessor :name, :associated_properties, :required

    def initialize(name, required)
      @name = name
      @required = required
      @associated_properties = []
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def inherited(klass)
      super
      klass.instance_variable_set('@properties', [])
    end

    def properties
      @properties
    end

    def property(property_name, options = {})
      required = options[:required] != false # default true
      new_prop = Property.new(property_name, required)
      if @parent_property
        @parent_property.associated_properties << new_prop
      else
        (@properties ||= []) << new_prop
      end

      if block_given?
        old_parent_property = @parent_property
        @parent_property = new_prop
        yield
        @parent_property = old_parent_property
      end
    end
  end

  def validate_request(request)
    @request_to_validate = request
    assert_required_attributes_set!
  end

  def raise_no_property_error!(property_name)
    raise PropertyNotSetError, "The property '#{property_name}' is not defined for #{self.class.name}"
  end

  private

  def assert_required_attributes_set!
    self.class.properties.each do |property|
      @parent_attributes = []
      assert_property_set!(property)
    end
  end

  def assert_property_set!(property)
    keys = @parent_attributes + [ property.name ]
    value = val_for(@request_to_validate, keys)
    if property.required && !value
      effective_property_name = keys.join(':')
      raise_no_property_error!(effective_property_name)
    else
      assert_associated_properties!(property) if value
    end
  end

  def assert_associated_properties!(property)
    if !property.associated_properties.empty?
      @parent_attributes.push(property.name)
      property.associated_properties.each do |associated_property|
        assert_property_set!(associated_property)
      end
      @parent_attributes.pop
    end
  end

  def val_for(object, keys)
    if object.class == Hash
      keys.inject(object) { |h, key| h[key.to_s] || h[key.to_sym] }
    else
      keys.inject(object) do |o, key|
        if o.respond_to? key
          o.send(key)
        else
          return nil
        end
      end
    end
  end

end