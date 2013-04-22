module Facebokr

  class Shell
    class Sandbox < BasicObject
      def initialize(app)
        @app = app
      end

      def access_token
        @app.access_token
      end
      alias_method :token, :access_token

      def test_user(options = {})
        @app.create_test_user(options)
      end
      alias_method :tu, :test_user

      def app_request(*args)
        @app.create_app_request(*args)
      end
      alias_method :ar, :app_request

      def app_notification(*args)
        @app.create_app_notification(*args)
      end
      alias_method :an, :app_notification
    end

    attr_accessor :app

    def initialize(app)
      @app = app
    end

    def run
      prompt
      $stdin.each_line do |line|
        $stdout.puts format Sandbox.new(app).instance_eval(line)
        prompt
      end
    end

    private

    def prompt
      $stdout.print '-> '
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

