App.Notebook = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    name:               attr('string'),
    color:              attr('string'),
    paperType:          attr('string'),
    carrierIdentifier:  attr('string'),
    notebookIdentifier: attr('string'),
    createdAt:          attr('date'),
    updatedAt:          attr('date'),

    user: DS.belongsTo('user'),
    pages: DS.hasMany('page', { async: true })
  });

}());

