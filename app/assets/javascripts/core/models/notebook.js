Core.Notebook = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    name:                  attr('string'),
    color:                 attr('string'),
    paperType:             attr('string'),
    carrierIdentifier:     attr('string'),
    notebookIdentifier:    attr('string'),
    state:                 attr('string'),
    pagesCount:            attr('string'),
    createdAt:             attr('date'),
    updatedAt:             attr('date'),
    submittedOn:           attr('date'),
    receivedOn:            attr('date'),
    uploadedOn:            attr('date'),
    processedOn:           attr('date'),
    availableOn:           attr('date'),
    returnedOn:            attr('date'),
    recycledOn:            attr('date'),

    user: DS.belongsTo('user'),
    pages: DS.hasMany('page', { async: true }),

    available: function() {
      return this.get('state') === "available";
    }.property(),

    unavailable: function() {
      return this.get('state') !== "available";
    }.property()
  });

}());
