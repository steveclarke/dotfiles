#!/usr/bin/env ruby

require 'rubygems'
require 'active_support/core_ext'

chars = (('a'..'z').to_a + ('A'..'Z').to_a)

time = Time.now.beginning_of_month
twelve_hours_from_now = 12.hours.from_now
end_of_next_month = 1.month.from_now.end_of_month

chars.each do |char|
  printf("%-8s %-25s %-25s %-25s\n",
         char,
         time.strftime("%#{char}").rstrip,
         twelve_hours_from_now.strftime("%#{char}").rstrip,
         end_of_next_month.strftime("%#{char}").rstrip)
end