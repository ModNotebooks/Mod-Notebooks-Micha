Ember.Handlebars.helper('humanize', function(value) {
  return Ember.String.humanize(value);
});

Ember.Handlebars.helper('format-date', function(date, format) {
  return moment(date).format(format);
});
