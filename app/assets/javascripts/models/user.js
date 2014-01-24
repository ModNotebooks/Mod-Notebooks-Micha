App.User = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    email:                attr('string'),
    password:             attr('string'),
    passwordConfirmation: attr('string'),
    createdAt:            attr('date'),
    updatedAt:            attr('date'),
    confirmedAt:          attr('date'),
    address:              attr(),

    notebooks: DS.hasMany('notebook')
  });

}());

