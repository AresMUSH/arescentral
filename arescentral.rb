require 'json'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/cross_origin'
#require 'thin'
require 'yaml'
require 'mongoid'
require 'bcrypt'
require 'sinatra/flash'
require 'i18n'
require 'timezone'
require 'redcarpet'
require 'sendgrid-ruby'
require 'securerandom'


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[.]))

require 'models/friendship'
require 'models/handle'
require 'models/linked_char'
require 'models/past_char'
require 'models/game'
require 'models/plugin'

require 'controllers/app'
require 'controllers/handles'
require 'controllers/games'
require 'controllers/login'
require 'controllers/api'
require 'controllers/misc'
require 'controllers/plugins'

require 'lib/helpers/admin_checker'
require 'lib/helpers/config'
require 'lib/helpers/database'
require 'lib/helpers/handle_finder'
require 'lib/helpers/mail'
require 'lib/helpers/owner_checker'
require 'lib/helpers/recaptcha'
require 'lib/helpers/sso'
require 'lib/helpers/timezones'

require 'lib/helpers/log_format/format_spec'
require 'lib/helpers/log_format/line_parser'
require 'lib/helpers/log_format/log_format_reader'
require 'lib/helpers/log_format/log_parser'

require 'lib/commands/api_game_register'
require 'lib/commands/api_reset_char_password'
require 'lib/commands/api_game_update'
require 'lib/commands/api_handle_friends'
require 'lib/commands/api_handle_link'
require 'lib/commands/api_handle_profile'
require 'lib/commands/api_handle_sync'
require 'lib/commands/api_handle_unlink'
require 'lib/commands/api_plugin_create'
require 'lib/commands/api_plugin_register'
require 'lib/commands/get_game_detail'
require 'lib/commands/get_handle_detail'
require 'lib/commands/get_handle_edit'
require 'lib/commands/get_handle_manage_char'
require 'lib/commands/get_handle_manage_friend'
require 'lib/commands/post_change_game_status'
require 'lib/commands/post_change_handle_status.rb'
require 'lib/commands/post_format_log'
require 'lib/commands/post_handle_edit'
require 'lib/commands/post_change_password'
require 'lib/commands/post_forgot_password'
require 'lib/commands/post_handle_add_char'
require 'lib/commands/post_handle_add_friend'
require 'lib/commands/post_handle_create'
require 'lib/commands/post_handle_delete_char'
require 'lib/commands/post_handle_delete_friend'
require 'lib/commands/post_handle_char_reset_password'
require 'lib/commands/post_login'
require 'lib/commands/post_sso_login'