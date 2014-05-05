#!/usr/bin/env ruby

require 'yahoo_finance'
# https://github.com/herval/yahoo-finance

# Check inupt params
if ARGV.length < 1 or (ARGV.length < 2 and ARGV[-1].to_i > 0)
	puts "Please enter at least one symbol"
	exit()
end

# Parameters
sleep_seconds = 60
symbols = ARGV
if symbols[-1].to_i > 0 # Last parameter is seconds parameter?
	sleep_seconds = symbols.pop.to_i
end

# Loop
data_old = nil
firstloop = true
while true do
	data = YahooFinance.quotes(symbols, [:ask, :change])
	data_changed = false

	symbols.each_with_index do |s, i|
		if firstloop or (data_old and data[i].ask == data_old[i].ask)
			print "[ %s: %.2f (%.2f%%) ]" % [s.upcase, data[i].ask.to_f, data[i].change.to_f]
		elsif data_old and data[i].ask > data_old[i].ask
			print "[ \033[32m%s: %.2f (%.2f%%)\033[0m ]" % [s.upcase, data[i].ask.to_f, data[i].change.to_f]
		else
			print "[ \033[31m%s: %.2f (%.2f%%)\033[0m ]" % [s.upcase, data[i].ask.to_f, data[i].change.to_f]
		end
		print " "
	end

	puts
	data_old = data
	firstloop = false
	sleep(sleep_seconds)
end
