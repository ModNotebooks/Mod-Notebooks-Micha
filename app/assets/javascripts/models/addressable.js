App.Addressable = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    address: DS.belongsTo('address')
  });

}());
