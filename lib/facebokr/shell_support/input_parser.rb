module Facebokr
  module ShellSupport

    class InputParser
      COMMAND_PATTERN = /(\w+)(?:\s*(.*))/

      def initialize(commands)
        @commands = commands
      end

      def parse_command(line)
        command_name, command_params = line.match(COMMAND_PATTERN)[1..2]
        @commands.find_by_name_or_alias(command_name)
      end
    end

  end
end

