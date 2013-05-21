# patch to setup redirect uri host for oauth2
# for example Google won't let you use custom tld, so here is a workaround
# not needed in production

module OmniAuth
  module Strategies
    class OAuth2
      def callback_url
        callback_path =~ /\/users\/auth\/(?<provider>[^\/]+)\/callback/
        provider = Regexp.last_match(:provider).to_sym
        Devise.omniauth_configs[provider].options[:redirect_uri_host] + script_name + callback_path
      rescue
        full_host + script_name + callback_path
      end
    end
  end
end