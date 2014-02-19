App.DigitizeCodeController = Ember.ObjectController.extend({
  needs: ['digitize', 'digitizeIndex'],

  code: null,
  error: null,
  completed: false,

  actions: {
    next: function() {
      var _this = this;

      this.canAdvance().then(function() {
        _this.send('advance');
      }, function() {
        _this.set("error", "Could not find notebook with the given code.");
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

  }

});
