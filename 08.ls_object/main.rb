# frozen_string_literal: true

require_relative 'argument'
require_relative 'ls_command'

argument = Argument.new
ls = LsCommand.new(argument)
ls.list_segment
