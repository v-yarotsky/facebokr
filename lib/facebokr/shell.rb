require 'readline'
require 'facebokr/shell_support/command'
require 'facebokr/shell_support/dsl'
require 'facebokr/shell_support/input_parser'

module Facebokr

  class Shell
    include ShellSupport::DSL

    command :access_token, :aliases => [:token], :description => "Get fb app access token" do |app|
      app.access_token
    end

    command :test_user, :aliases => [:tu], :description => "Create a test fb user" do |app|
      app.create_test_user
    end

    command :app_request, :aliases => [:ar], :description => "Issue an app request" do |app, *args|
      app.create_app_request(*args)
    end

    command :app_notification, :aliases => [:an], :description => "Issue an app notification" do |app, *args|
      app.create_app_notification(*args)
    end

    attr_accessor :app

    def initialize(app)
      @app = app
      @input_parser = ShellSupport::InputParser.new(self.class.commands)
    end

    def run
      while buf = Readline.readline(prompt, true) do
        command = @input_parser.parse_command(buf)
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

