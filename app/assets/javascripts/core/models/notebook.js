Core.Notebook = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    name:                  attr('string'),
    color:                 attr('string'),
    paper:                 attr('string'),
    carrierIdentifier:     attr('string'),
    notebookIdentifier:    attr('string'),
    state:                 attr('string'),
    pagesCount:            attr('string'),
    handleMethod:          attr('string'),
    createdAt:             attr('date'),
    updatedAt:             attr('date'),
    submittedOn:           attr('date'),
    receivedOn:            attr('date'),
    uploadedOn:            attr('date'),
    processedOn:           attr('date'),
    availableOn:           attr('date'),
    returnedOn:            attr('date'),
    recycledOn:            attr('date'),
    coverImage:            attr('string'),
    coverImageRetina:      attr('string'),

    user: DS.belongsTo('user'),
    pages: DS.hasMany('page', { async: true }),

    style: function() {
      var css = "background-color: " + this.get('color') + ";";

      if (this.get('hasCoverImage')) {
        css += "background-image: url(" + this.get('coverImageURL') + ");"
      }

      return css;
    }.property('color'),

    coverImageURL: function() {
      return window.devicePixelRatio > 1 ? this.get('coverImageRetina') : this.get('coverImage');
    }.property('coverImage', 'coverImageRetina'),

    hasCoverImage: function() {
      return !Ember.isEmpty(this.get("coverImageURL"));
    }.property('coverImageURL'),

    available: function() {
      return this.get('state') === "available";
    }.property('state'),

    unavailable: function() {
      return this.get('state') !== "available";
    }.property('state')
  });

}());
