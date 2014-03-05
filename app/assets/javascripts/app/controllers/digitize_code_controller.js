App.DigitizeCodeController = Ember.Controller.extend({
  needs: ['digitize', 'digitizeIndex'],

  code: null,
  name: null,
  error: null,
  completed: false,

  actions: {
    advance: function() {
      var _this = this;
      this.canAdvance().then(function() {
        _this.set('error', null);
        _this.set('completed', true);
        _this.transitionToRoute('digitize.scan')
      }, function() {
        _this.set('error', 'Invalid code.');
      });
    },
  },

  canAdvance: function() {
    var code = this.get('code');

    return new Ember.RSVP.Promise(function(resolve, reject) {
      if (Ember.isEmpty(code)) {
        reject();
      } else {
        var data = { "notebook": { "notebook_identifier": code } };

        Ember.$.ajax({
          type: "POST",
          url: window.ENV.API_ENDPOINT + '/notebooks/exists.json',
          dataType: 'json',
          data: data,
          error: reject,
          success: resolve
        });
      }
    });
  },

  codeChanged: function() {
    this.set('error', null);
  }.observes('code')

});
