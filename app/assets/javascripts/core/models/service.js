Core.Service = (function() {

  var attr = DS.attr;

  return DS.Model.extend({
    type:           attr('string'),
    provider:       attr('string'),
    uid:            attr('string'),
    name:           attr('string'),
    email:          attr('string'),
    nickname:       attr('string'),
    token:          attr('string'),
    secret:         attr('string'),
    refreshToken:   attr('date'),
    expiresAt:      attr('date'),
    meta:           attr(),
    disabledAt:     attr('date'),
    disabledReason: attr('string'),
    disabledData:   attr(),
    createdAt:      attr('date'),
    updatedAt:      attr('date'),


    user: DS.belongsTo('user'),

    disabled: function() {
      return !Ember.isEmpty(this.get('disabledAt'));
    }.property('disabledAt'),

    enabled: function() {
      return Ember.isEmpty(this.get('disabledAt'));
    }.property('disabledAt'),

    authURL: function() {
      var host = window.location.host,
          name = this.get('provider');

      return "//" + host + "/auth/" + name;
    }.property('provider'),

  });

}());

