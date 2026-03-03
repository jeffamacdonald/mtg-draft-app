# Stub sassc file to prevent LoadError when Sprockets tries to require it
# We handle SCSS compilation with yarn build:css instead

module SassC
  class Engine
    def initialize(*)
      # Stub implementation
    end
    
    def render
      ""
    end
  end
end
