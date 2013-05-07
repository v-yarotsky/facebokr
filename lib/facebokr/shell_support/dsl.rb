require 'facebokr/shell_support/command'

module Facebokr
  module ShellSupport

    module DSL
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def command(name, options = {}, &block)
          command = Command.new(String(name), options[:description], options[:aliases], &block)
          commands << command
        end

        def commands
          @commands ||= begin
            c = []
            def c.find_by_name_or_alias(name_or_alias)
              detect { |c| c.name == name_or_alias }
            end
            c
          end
        end
      end
    end

  end
end
