require 'redmine'

require_dependency 'redmine_slack/listener'

Redmine::Plugin.register :redmine_slack do
	name 'Redmine Slack'
	author 'Samuel Cormier-Iijima'
	url 'https://github.com/keitetran/redmine-slack'
	author_url 'http://www.sciyoshi.com'
	description 'Slack chat integration edited by Keite'
	version '0.2.1'

	requires_redmine :version_or_higher => '0.8.0'

	settings \
		:default => {
			'callback_url' => 'http://slack.com/callback/',
			'channel' => nil,
			'icon' => 'https://raw.github.com/sciyoshi/redmine-slack/gh-pages/icon.png',
			'username' => 'redmine',
			'display_watchers' => 'no'
		},
		:partial => 'settings/slack_settings'
end

((Rails.version > "5")? ActiveSupport::Reloader : ActionDispatch::Callbacks).to_prepare do
	require_dependency 'issue'
	unless Issue.included_modules.include? RedmineSlack::IssuePatch
		Issue.send(:include, RedmineSlack::IssuePatch)
	end
end
