Core.Page = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    index: attr('string'),
    image: attr(),

    user: DS.belongsTo('user'),
    notebook: DS.belongsTo('notebook'),

    pageNumber: function() {
      return parseInt(this.get('index'), 10) + 1;
    }.property('index')
  });

}());

