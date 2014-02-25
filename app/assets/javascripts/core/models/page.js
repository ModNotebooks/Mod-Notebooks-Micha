Core.Page = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    index: attr('number'),
    position: attr('number'),
    image: attr(),
    nextPage: attr(),
    previousPage: attr(),

    user: DS.belongsTo('user'),
    notebook: DS.belongsTo('notebook'),

    pageNumber: function() {
      return this.get('index') + 1;
    }.property('index'),

    isFirstPage: function() {
      return Ember.isEmpty(this.get('previousPage'));
    }.property('previousPage'),

    isLastPage: function() {
      return Ember.isEmpty(this.get('nextPage'));
    }.property('nextPage'),

    leftPageIndex: function() {
      var index = this.get('index');
      var indexEven = (index % 2 ) === 0;

      if (this.get('isFirstPage')) {
        return 0;
      }

      if (indexEven) {
        return index;
      } else {
        return index - 1;
      }
    }.property('index'),

    rightPageIndex: function() {
      var index = this.get('index');
      var indexEven = (index % 2 ) === 0;

      if (this.get('isFirstPage')) {
        return index;
      }

      if (indexEven) {
        return index + 1;
      } else {
        return index;
      }
    }.property('index')
  });

}());

