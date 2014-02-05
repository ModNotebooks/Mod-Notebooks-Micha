Core.Notebook = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    name:                  attr('string'),
    color:                 attr('string'),
    paperType:             attr('string'),
    carrierIdentifier:     attr('string'),
    notebookIdentifier:    attr('string'),
    currState:             attr('string'), // currentState clashes with ember
    currentStateAt:        attr('date'),
    currentProcessState:   attr('string'),
    currentProcessStateAt: attr('string'),
    pagesCount:            attr('string'),
    createdAt:             attr('date'),
    updatedAt:             attr('date'),

    user: DS.belongsTo('user'),
    pages: DS.hasMany('page', { async: true }),

    processed: function() {
      return this.get('currentProcessState') === "processed";
    }.property('currentProcessState'),

    notProcessed: function() {
      return !this.get('processed');
    }.property('processed')
  });

}());
