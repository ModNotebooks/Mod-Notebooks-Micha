Ember.Handlebars.registerBoundHelper('humanize', function(value) {
  return Ember.String.humanize(value);
});

Ember.Handlebars.registerBoundHelper('format-date', function(date, format) {
  return moment(date).format(format);
});

Ember.Handlebars.registerBoundHelper('format-errors', function(errors) {
  errors = errors.reduce(function(memo, item) {
    memo.push(item.attribute.decamelize().humanize() + " " + item.message);
    return memo;
  }, []);

  return errors.join(', ');
});

