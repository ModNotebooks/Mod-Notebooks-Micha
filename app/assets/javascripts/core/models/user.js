Core.User = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    email:                attr('string'),
    password:             attr('string'),
    passwordConfirmation: attr('string'),
    currentPassword:      attr('string'),
    confirmedAt:          attr('date'),

    notebooks: DS.hasMany('notebook'),
    services: DS.hasMany('service')
  });

}());

