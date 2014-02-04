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
    connectionToggle: attr('boolean'),

    user: DS.belongsTo('user'),

    isConnected: function() {
      return !Ember.isEmpty(this.get('token')) && !Ember.isEmpty(this.get('secret'));
    }.property('token', 'secret'),

    authURL: function() {
      var host = window.location.host,
          name = this.get('provider');

      return "//" + host + "/auth/" + name;
    }.property('provider'),

  });

}());

