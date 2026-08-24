
Redmine::Plugin.register :redmine_impersonate do
  name "Redmine Impersonate"
  author "Ralph Gutkowski"
  description "Login as any user with click of a button."
  version '2.1.0'
  url 'https://github.com/rgtk/redmine_impersonate'
  author_url 'https://github.com/rgtk'

  requires_redmine version_or_higher: '6.1'
end

RedmineImpersonate.install
