[![Code Climate](https://codeclimate.com/github/kaspernj/gettext_simple_rails.png)](https://codeclimate.com/github/kaspernj/gettext_simple_rails)
[![Test Coverage](https://codeclimate.com/github/kaspernj/gettext_simple_rails/badges/coverage.svg)](https://codeclimate.com/github/kaspernj/gettext_simple_rails)

# GettextSimpleRails

Translate your app with Gettext that converts into I18n translations. Detects most common translations and maintains adding and removing those translations by inspecting your app through a simple Rake-task.

## Supports
- Most validation error messages on models by inspecting application models
- Model names and attributes by inspecting application models
- Date specific texts like month names, day names, formats and so on.
- ActiveAdmin
- Devise
- PaperClip

# Install

## Addting to application and creating appropriate files.
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

## Installing and setting up POEdit
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


## Updating model-translations after changes.

```sh
rake gettext_simple_rails:all
```

Open .po-files with POEdit, press "Update", solve translations, press "Save" and restart your app.


# Usage

## Adding translated texts to your app

To do a normal translation anywhere in your app, it is useally done through the "_"-method in english like so:
```erb
<%= _("Hello world") %>
```

All you need to do in order to get that translated, is to open POEdit for the language you wish to translate, press update, translate the new found text, press save and restart your app.

## Variables in translations
```erb
<%= _("My name is %{name}", :name => "Kasper") %>
```

## Adding another language

This is done through I18n in "application.rb". Add your language to `I18n.available_locales`. Then run `rake gettext_simple_rails:create` to create a sample file (to avoid doing the catalog setup yourself), open the file and begin translating.

## Setting the current language.

This is done as your normally would through `I18n.locale=`.

## Model names

As with I18n:
```erb
<%= User.model_name.human %>
```

## Model attributes

As with I18n:
```erb
<%= User.human_attribute_name(:name) %>
```
