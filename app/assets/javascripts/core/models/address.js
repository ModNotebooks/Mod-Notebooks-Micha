Core.Address = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    name:       attr('string'),
    line_1:     attr('string'),
    line_2:     attr('string'),
    city:       attr('string'),
    region:     attr('string'),
    postalCode: attr('string'),
    country:    attr('string'),

    addressable: DS.belongsTo('addressable', { polymorphic: true })
  });

}());

