//= require_self
//= require ./store
//= require ./models/addressable
//= require_tree ./models

Core = Ember.Namespace.create({ name: "Core" });
Ember.Inflector.inflector.irregular('preferences', 'preferences');
