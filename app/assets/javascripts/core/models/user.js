Core.User = (function() {

  var attr = DS.attr;

  return Core.Addressable.extend({
    email:                attr('string'),
    password:             attr('string'),
    passwordConfirmation: attr('string'),
    createdAt:            attr('date'),
    updatedAt:            attr('date'),
    confirmedAt:          attr('date'),

    notebooks: DS.hasMany('notebook'),
  });

}());

