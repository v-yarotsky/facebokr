require 'open-uri'
require 'uri'
require 'json'

module Facebokr
  GRAPH_URI = "https://graph.facebook.com"

  class App
    #
    # @param app_id [String] Facebook application id
    # @param app_secret [String] Facebook application secret
    #
    def initialize(app_id, app_secret)
      @app_id     = app_id
      @app_secret = app_secret
    end

    def access_token
      @access_token ||= begin
        uri = og_uri("oauth/access_token", :client_id => @app_id, :client_secret => @app_secret, :grant_type => "client_credentials")
        response = open(uri).read
        response.gsub(/^access_token=/, "")
      end
    end

    # Creates a test user for given Facebook application
    #
    # @param options [Hash] Facebook test user options
    # @option installed [Boolean] Automatically install application for test user
    # @option permissions [String] Comma-separated list of FB OG permissions
    #
    def create_test_user(options = {})
      uri = og_uri(@app_id, "accounts/test-users", options.merge(:access_token => access_token))
      response = JSON.parse(open(uri).read)
      response["data"].first
    end

    # Creates an app request from given Facebook application
    #
    # @param fb_user_id [String] Facebook user id
    # @param message [String] Request message text
    # @param data [String] Optional request data
    #
    def create_app_request(fb_user_id, message, data = "")
      uri = og_uri(fb_user_id, "apprequests")
      post_to_og(uri, :access_token => access_token, :message => message, :data => data)
    end

    # Creates an app notification from given Facebook application
    #
    # @param fb_user_id [String] Facebook user id
    # @param template [String] Notification message template
    # @param href [String] optional href (relative path) to redirect user to
    #
    def create_app_notification(fb_user_id, template, href = "")
      uri = og_uri(fb_user_id, "notifications")
      post_to_og(uri, :access_token => access_token, :template => template, :href => href)
    end

    private

    def og_uri(*path_elements)
      params = path_elements.last.is_a?(Hash) ? path_elements.pop : {}
      wrapped_path = path_elements.join("/").gsub(/(.*)/, "/\\1").squeeze("/").chop
      query = params.map { |k, v| "#{k}=#{URI.escape v.to_s}" }.join("&")
      URI.join(GRAPH_URI, wrapped_path).tap { |u| u.query = query unless String(query).empty? }
    end

    def post_to_og(uri, params = {})
      require 'net/http'
      request = Net::HTTP::Post.new(uri.path)
      request.form_data = params
      session = Net::HTTP.new(uri.host, uri.port)
      session.use_ssl = true
      response = session.start do |http|
        http.use_ssl = true
        http.request(request)
      end
      JSON.parse(response.body)
    end
  end

end

