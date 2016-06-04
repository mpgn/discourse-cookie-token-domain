# name: discourse-cookie-token-domain
# about: add a cookie token to allow authentication for cross domain
# version: 0.1
# authors: mpgn

enabled_site_setting :cookie_ui_enabled

load File.expand_path("../current_user_provider.rb", __FILE__)

Discourse.current_user_provider = ExCurrentUserProvider
