require 'readline'
require 'facebokr/error_handling'
require 'facebokr/shell_support/command'
require 'facebokr/shell_support/dsl'
require 'facebokr/shell_support/input_parser'

module Facebokr

  class Shell
    include ShellSupport::DSL

    command :help do |c|
      c.shortcut :h
      c.description "Show available commands"
      c.run do |*|
        result = "Available commands:\n\n"
        print_command = proc { |cmd| result += "%-40s - %s\n" % [cmd.name, cmd.description] }
        commands.partition { |c| !%w(help quit).include? c.name.name }.each do |some_commands|
          some_commands.sort_by(&:name).each(&print_command)
          result += "\n"
        end
        result.chomp
      end
    end

    command :quit do |c|
      c.description "Quit facebokr"
      c.run { |*| exit 0 }
    end

    command :access_token do |c|
      c.shortcut :token
      c.description "Get fb app access token"
      c.run { |_, app| app.access_token }
    end

    command :test_user do |c|
      c.shortcut :tu
      c.description "Create a test fb user"
      c.run { |_, app| app.create_test_user }
    end

    command :app_request do |c|
      c.shortcut :ar
      c.description "Issue an app request"
      c.run { |params, app| app.create_app_request(params[:fb_user_id], params[:message], params[:data]) }
    end

    command :app_notification do |c|
      c.shortcut :an
      c.description "Issue an app notification"
      c.run { |params, app| app.create_app_notification(params[:fb_user_id], params[:template], params[:href].to_s) }
    end

    attr_accessor :app

    def initialize(app)
      @app = app
      @input_parser = ShellSupport::InputParser.new(self.class.commands)
    end

    def run
      while buf = Readline.readline(prompt, true) do
        run_command(buf)
      end
    end

    def run_command(str)
      Facebokr.with_error_handling do
        command = @input_parser.parse_command(str)
        puts format command[@app]
      end
    end

    private

    def prompt
      '-> '
    end

    def format(obj)
      case obj
      when String
        obj
      when Hash
        obj.map { |data| "%-20s: %s" % data }.join("\n")
      when Array
        obj.map(&method(:format)).join("\n")
      else
        obj.inspect
      end
    end
  end

end

