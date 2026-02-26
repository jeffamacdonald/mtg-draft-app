# Create a stub sassc.rb file in lib directory to prevent LoadError
# We don't actually use sassc since we handle SCSS with yarn build:css

require 'fileutils'

sassc_stub_path = Rails.root.join('lib', 'sassc.rb')
FileUtils.mkdir_p(File.dirname(sassc_stub_path))

unless File.exist?(sassc_stub_path)
  File.write(sassc_stub_path, <<~RUBY)
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
  RUBY
end

# Add lib directory to load path so sassc.rb can be found
$LOAD_PATH.unshift(Rails.root.join('lib')) unless $LOAD_PATH.include?(Rails.root.join('lib').to_s)
