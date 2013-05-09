require 'readline'
require 'shellissimo'

module Facebokr

  class Shell < Shellissimo::Shell
    facebook_user_id_param = proc do |p|
      p.description "Facebook user id"
      p.validate { |v| /\d+/ =~ v.to_s }
    end

    command :access_token do |c|
      c.shortcut :token
      c.description "Get fb app access token"
      c.run { @app.access_token }
    end

    command :test_user do |c|
      c.shortcut :tu
      c.description "Create a test fb user"
      c.run { @app.create_test_user }
    end

    command :app_request do |c|
      c.shortcut :ar
      c.description "Issue an app request"

      c.mandatory_param(:fb_user_id, &facebook_user_id_param)
      c.mandatory_param(:message)
      c.param(:data) do |p|
        p.description "Application Request payload string"
      end

      c.run { |params| @app.create_app_request(params[:fb_user_id], params[:message], params[:data]) }
    end

    command :app_notification do |c|
      c.shortcut :an
      c.description "Issue an app notification"

      c.mandatory_param(:fb_user_id, &facebook_user_id_param)
      c.mandatory_param(:template)
      c.param(:href) do |p|
        p.description "Optional href (relative) to redirect to"
      end

      c.run { |params| @app.create_app_notification(params[:fb_user_id], params[:template], params[:href].to_s) }
    end

    attr_accessor :app

    def initialize(app)
      @app = app
      super
    end
  end

end

