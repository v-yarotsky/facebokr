require 'facebokr/shell_support/command_name'

module Facebokr
  module ShellSupport

    class Command
      attr_reader :name, :aliases, :description, :params, :block

      def initialize(name, description = "", aliases = [],  params = [], &block)
        @name, @description, @params = CommandName.new(name, aliases), String(description), params
        @block = block or raise ArgumentError, "command block is required"
      end

      def call(*args)
        block.call(*args)
      end
      alias_method :[], :call
    end

  end
end

