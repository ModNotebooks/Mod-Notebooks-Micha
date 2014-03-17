// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require env
//= require handlebars
//= require momentjs/moment
//= require ember
//= require ember-data
//= require ember-simple-auth
// require ember-animated-outlet
//= require ember-radio-buttons
//= require nprogress/nprogress
//= require_self
//= require core/core
//= require app/app
//= require settings/settings

// for more details see: http://emberjs.com/guides/application/

(function() {

  window.Core = Ember.Namespace.create({});

  Ember.LinkView.reopen({
    activeClass: "is-active",
    disabledClass: "is-disabled"
  });

  Ember.DefaultResolver.reopen({
    resolveModel: function(parsedName) {
      var className = Ember.String.classify(parsedName.name),
            factory = Ember.get(Core, className);

      if (factory) { return factory; }
    }
  });

  Ember.Application.reopen(window.ENV.APPLICATION_OPTIONS || {});

  var MainApp = Ember.Application.create({
    name: 'main',
    rootElement: '#main',
    Resolver: Ember.DefaultResolver.extend()
  });

  var SettingsApp = Ember.Application.create({
    name: 'settings',
    rootElement: '#settings',
    Resolver: Ember.DefaultResolver.extend()
  });

  MainApp.Router.reopen({
    location: 'history'
  });

  SettingsApp.Router.reopen({
    location: 'none'
  });

  window.App = MainApp;
  window.Settings = SettingsApp;
}());

//= require_tree .
