module Enumerable
  extend ActiveSupport::Concern

  module ClassMethods

    def get_key(value)
      self.all.each_pair do |key, val|
        return key if val == value
      end
      raise ArgumentError, "Value not found: #{value}"
    end

    def options(image_picker=nil)
      self.all.invert.map do |value, key|
        if image_picker
          image_picker.default = ''
          [value, key, { 'data-img-src' => "/assets#{image_picker[:path]}/#{value}" }]
        else
          [value, key]
        end
      end
    end
  end
end
