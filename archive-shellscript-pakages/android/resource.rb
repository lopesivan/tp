#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-

require 'rubygems'
require 'haml'
require 'manifest'
require 'layoutmain'

##############################################################################
##############################################################################
##############################################################################

def parser(ifile, ofile)
	template    = File.read(ifile)
	haml_engine = Haml::Engine.new(template)
	output      = haml_engine.render
	puts output

	f = File.open(ofile, "w")
	f.puts output
	f.close
end

def dparser(ifile)
	template    = File.read(ifile)
	haml_engine = Haml::Engine.new(template)
	output      = haml_engine.render
	puts output

#	f = File.open(ofile, "w")
#	f.puts output
#	f.close
end
# ----------------------------------------------------------------------------
#

parser(ARGV[0], ARGV[1])
