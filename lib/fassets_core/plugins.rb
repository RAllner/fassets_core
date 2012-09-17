module FassetsCore
  class Plugins
    def self.register plugin
      @@my_plugins << plugin
    end

    def self.all
      @@my_plugins
    end
    private
    @@my_plugins = []
  end
end