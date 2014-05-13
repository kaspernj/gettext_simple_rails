# GettextSimpleRails

Translate your app with Gettext that converts into I18n translations. Detects most common translations and maintains adding and removing those translations by inspecting your app through a simple Rake-task.

# Install

Start by putting it into your Gemfile and bundle it:
```ruby
gem 'gettext_simple_rails'
```

Now add a initializer in the "lib"-folder or "config/initializers" with this content:

```ruby
class GettextSimpleInitializer
  def self.run
    require "gettext_simple"
    gettext_simple = GettextSimple.new(:i18n => true)
    gettext_simple.load_dir("#{Rails.root}/config/locales_gettext")
    gettext_simple.register_kernel_methods

    injector = GettextSimpleRails::I18nInjector.new
    injector.inject_model_translations(gettext_simple)
    injector.inject_translator_translations(gettext_simple)
  end
end
```

Add the following line to "environment.rb":
```ruby
...
YourApp::Application.initialize!
GettextSimpleInitializer.run
...
```

To inspect your app and add the approipate .rb-files for POEdit to detect and read from run the following Rake task:
```sh
rake gettext_simple_rails:all
```

Now run POEdit and save your .po-files in "config/locales_gettext".
