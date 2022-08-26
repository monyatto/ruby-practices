# frozen_string_literal: true

require_relative 'command_options'
require_relative 'ls_command'

command_options = CommandOptions.new
ls = LsCommand.new(command_options)
ls.list_segment
