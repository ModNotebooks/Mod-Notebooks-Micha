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
//= require app

// for more details see: http://emberjs.com/guides/application/
App = Ember.Namespace.create({ name: "App" });

Main = App.Main = Ember.Application.extend()

Main.create({
  LOG_ACTIVE_GENERATION: true,
  LOG_MODULE_RESOLVER: true,
  LOG_TRANSITIONS: true,
  LOG_TRANSITIONS_INTERNAL: true,
  LOG_VIEW_LOOKUPS: true
});

Settings = Ember.Application.create({
  LOG_ACTIVE_GENERATION: true,
  LOG_MODULE_RESOLVER: true,
  LOG_TRANSITIONS: true,
  LOG_TRANSITIONS_INTERNAL: true,
  LOG_VIEW_LOOKUPS: true
});

Main.Router.reopen({
  location: 'none',

  rootElement: ''
});

Ember.LinkView.reopen({
  activeClass: "is-active",
  disabledClass: "is-disabled"
});

//= require_tree .
