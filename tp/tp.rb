#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-

require "thor"

class App < Thor

	desc "ls", "lista as opçoes de comandos"
	def ls(from=nil)
		if from
			puts "from: #{from}"
		else
			puts `tp ls --`
		end
	end
end

App.start ARGV

