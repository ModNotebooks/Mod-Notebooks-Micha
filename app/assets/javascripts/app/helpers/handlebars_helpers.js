Ember.Handlebars.helper('humanize', function(value) {
  return Ember.String.humanize(value);
});

Ember.Handlebars.helper('format-date', function(date, format) {
  return moment(date).format(format);
});

Ember.Handlebars.registerBoundHelper('renderSettingsTab', function(callingContext, tab, options) {
  return Ember.Handlebars.helpers.render.call(callingContext, tab.get('tabId'), 'settings', options);
});

