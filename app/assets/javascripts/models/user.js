App.User = (function() {

  var attr = DS.attr;

  return DS.Model.extend(Ember.Validations.Mixin, {
    email:                attr('string'),
    password:             attr('string'),
    passwordConfirmation: attr('string'),
    createdAt:            attr('date'),
    updatedAt:            attr('date'),
    confirmedAt:          attr('date'),
  });

}());

