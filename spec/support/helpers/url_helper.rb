module UrlHelper
  def token_endpoint_url(options = {})
    parameters = {
      :code          => options[:code],
      :client_id     => options[:client_id]     || (options[:client] ? options[:client].uid : nil),
      :client_secret => options[:client_secret] || (options[:client] ? options[:client].secret : nil),
      :redirect_uri  => options[:redirect_uri]  || (options[:client] ? options[:client].redirect_uri : nil),
      :grant_type    => options[:grant_type]    || "authorization_code",
    }
    "/oauth/token?#{build_query(parameters)}"
  end

  def authorization_endpoint_url(options = {})
    parameters = {
      :client_id     => options[:client_id]     || options[:client].uid,
      :redirect_uri  => options[:redirect_uri]  || options[:client].redirect_uri,
      :response_type => options[:response_type] || "code",
      :scope         => options[:scope],
      :state         => options[:state],
    }.reject { |k, v| v.blank? }
    "/oauth/authorize?#{build_query(parameters)}"
  end

  def refresh_token_endpoint_url(options = {})
    parameters = {
      :refresh_token => options[:refresh_token],
      :client_id     => options[:client_id]     || options[:client].uid,
      :client_secret => options[:client_secret] || options[:client].secret,
      :grant_type    => options[:grant_type]    || "refresh_token",
    }
    "/oauth/token?#{build_query(parameters)}"
  end

  def build_query(hash)
    Rack::Utils.build_query(hash)
  end

  def basic_auth_header_for_client(client)
    "Basic #{Base64.encode64("#{client.uid}:#{client.secret}")}"
  end
end

RSpec.configuration.send :include, UrlHelper, :type => :request
