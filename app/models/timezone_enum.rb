require 'concerns/enumerable'

class TimezoneEnum
  include Enumerable

  @@timezones = ActiveSupport::TimeZone.all.map { |tz| tz.to_s.delete('()') }.sort

  def self.all(as_list=false)
    as_list ? @@timezones : Hash[@@timezones.each.map { |tz| [tz, tz] }]
  end
end
