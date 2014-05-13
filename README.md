# GettextSimpleRails

Translate your app with Gettext that converts into I18n translations. Detects most common translations and maintains adding and removing those translations by inspecting your app through a simple Rake-task.

# Install

Start by putting it into your Gemfile and bundle it:
```ruby
gem 'gettext_simple_rails'
```

Now create sample .po-files to get started quickly:
```sh
bundle exec rake gettext_simple_rails:create
```

Now add a initializer in the "lib"-folder or "config/initializers" with this content:

Add the following line to "environment.rb". It has to be added here, since the translations have to be added after the normal initializations.
```ruby
...
YourApp::Application.initialize!
GettextSimpleRails.init
...
```

To inspect your app and add the appropriate .rb-files for POEdit to detect and read from run the following Rake task:
```sh
rake gettext_simple_rails:all
```

If you haven't install POEdit, you can install it like this under Ubuntu:
```sh
sudo apt-get install poedit
```

If you haven't set up POEdit with Ruby, you should install rgettext_poedit and use a Rake task to add Ruby as a parser:
```
gem install rgettext_poedit
bundle exec rake gettext_simple_rails:create_poedit_ruby_parser
```

Now open a .po-file located under "config/locales_gettext/[LOCALE]/LC_MESSAGES/default.po" with POEdit. Press "Update" and the translations from your add should appear in the list.

Solve those translations and press save.

Restart your Rails-app. The translations should now work.
