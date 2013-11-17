module Enumerable
  extend ActiveSupport::Concern

  module ClassMethods
    def get_key(value)
      self.all.each_pair do |key, val|
        return key if val == value
      end
      raise ArgumentError, "Value not found: #{value}"
    end
  end
end
