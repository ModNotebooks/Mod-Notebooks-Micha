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
//= require jquery
//= require handlebars
//= require ember
//= require ember-data
//= require ember-simple-auth
//= require ember-easyForm/validations/ember-validations-1.0.0.beta.1
//= require ember-easyForm/easyForm/ember-easyForm-1.0.0.beta.1
//= require_self
//= require app

// for more details see: http://emberjs.com/guides/application/
App = Ember.Application.create({
  LOG_TRANSITIONS: true,
  LOG_ACTIVE_GENERATION: true,
  OAUTH_ID: "3bb761a843711dad62fea243a4674843310f474fc8a757c714992cdd0f39d681",
  OAUTH_SECRET: "32dfc56b1e0d32a14bfa2ffcc97e5d7409485d1a268ede11f8fa83713092f539"
});

//= require_tree .
