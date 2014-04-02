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
//= require_self
//= require partner/app

(function() {

  Ember.LinkView.reopen({
    activeClass: "is-active",
    disabledClass: "is-disabled"
  });

  window.App = Ember.Application.create(window.ENV.APPLICATION_OPTIONS || {});

}());
