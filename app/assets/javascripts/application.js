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
//= require environment
//= require jquery
//= require handlebars
//= require momentjs/moment
//= require ember
//= require ember-data
//= require ember-simple-auth
//= require tweenjs/examples/js/RequestAnimationFrame
//= require tweenjs/build/tween.min
//= require_self
//= require core/core
//= require app/app
//= require settings/settings
//= require store

// for more details see: http://emberjs.com/guides/application/

(function() {

  Ember.LinkView.reopen({
    activeClass: "is-active",
    disabledClass: "is-disabled"
  });

  Ember.DefaultResolver.reopen({
    templateNamespace: '',

    resolveTemplate: function(parsedName) {
      parsedName.fullNameWithoutType = this.get('templateNamespace') + parsedName.fullNameWithoutType;
      var resolvedTemplate = this._super(parsedName);
      if (resolvedTemplate) { return resolvedTemplate; }
      return Ember.TEMPLATES['not_found'];
    }
  });

  Ember.Application.reopen({
    LOG_ACTIVE_GENERATION: true,
    LOG_MODULE_RESOLVER: true,
    LOG_TRANSITIONS: true,
    LOG_TRANSITIONS_INTERNAL: true,
    LOG_VIEW_LOOKUPS: true,
  });

  var MainApp = Ember.Application.create({
    name: 'mod',
    rootElement: '#main',
    Resolver: Ember.DefaultResolver.extend({ templateNamespace: 'app/' })
  });

  var SettingsApp = Ember.Application.create({
    name: 'mod-settings',
    rootElement: '#settings',
    Resolver: Ember.DefaultResolver.extend({ templateNamespace: 'settings/' }),

    // Such a shitty hack!
    isVisible: function() {
      return this.__container__.lookup('controller:application').get('isVisible');
    }
  });

  MainApp.Router.reopen({
    location: 'history',
  });

  SettingsApp.Router.reopen({
    location: 'none',
  });

  window.App = MainApp;
  window.Settings = SettingsApp;
}());

//= require_tree .
