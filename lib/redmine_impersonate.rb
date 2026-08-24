module RedmineImpersonate
  # Redmine 6 laedt das lib-Verzeichnis eines Plugins ueber Zeitwerk
  # (Redmine::PluginLoader.add_autoload_paths). Vom Autoloader verwaltete
  # Dateien duerfen nicht per `require` geladen werden; es genuegt, die
  # Konstante zu referenzieren. Beim Laden registriert sich der ViewListener
  # ueber Redmine::Hook::Listener.inherited selbst bei Redmine::Hook.
  def self.install
    Hook::ViewListener
  end
end
