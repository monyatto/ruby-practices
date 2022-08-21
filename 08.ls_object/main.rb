# frozen_string_literal: true

require_relative 'argument'
require_relative 'directory'

argument = Argument.new
dir = Directory.new(argument)
dir.list_segment
