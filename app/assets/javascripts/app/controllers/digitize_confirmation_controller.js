App.DigitizeConfirmationController = Ember.ObjectController.extend({
  needs: ['digitize', 'digitizeCode', 'digitizeScan'],

  isLoading: false,

  actions: {
    submit: function() {
      var _this = this;
      var notebookIdentifier = this.get('controllers.digitizeCode.code');
      var notebookName       = this.get('controllers.digitizeCode.name');
      var handleMethodName   = this.get('controllers.digitizeScan.handleMethodName');
      var handleMethod       = this.get('controllers.digitizeScan.handleMethod');

      if (notebookIdentifier && handleMethod) {
        var notebook = this.get('content');

        notebook.setProperties({
          'notebookIdentifier': notebookIdentifier,
          'handleMethod': handleMethodName,
          'name': notebookName
        });

        notebook.save().then(function() {
          _this.set('isLoading', false);

          if (notebook.get('handleMethod') === 'return') {
            window.location = window.ENV.STORE_ENDPOINT + '/pages/return-notebook';
          } else if (handleMethod === "2") {
            window.location = window.ENV.STORE_ENDPOINT + '#order';
          } else {
            _this.transitionToRoute('notebooks');
          }
        }, function(err) {
          _this.set('isLoading', false);
        });
      } else {
        Ember.run.later(this, function() {
          this.set('isLoading', false);
        });
      }
    }
  },

  buttonText: function() {
    var handleMethod = this.get('controllers.digitizeScan.handleMethod');

    if (handleMethod === "1") {
      return "OK, take me to the app";
    } else if (handleMethod === "2") {
      return "OK, take me to buy my next notebook";
    } else if (handleMethod === "3") {
      return "OK, take me to the checkout";
    }

  }.property('controllers.digitizeScan.handleMethod'),

  stepOne: function() {
    return "Place your notebook inside the envelope that's inside the pocket in the back page, and mail it back to us.";
  }.property(),

  stepTwo: function() {
    return "We'll receive your notebook in 5 days.";
  }.property(),

  stepThree: function() {
    return "Our team will scan, digitize, and upload your digitized notebook to your account. We'll notify you then when it's ready";
  }.property(),

  stepFour: function() {
    var handleMethod = this.get('controllers.digitizeScan.handleMethod');

    if (handleMethod === "3") {
      return "We'll ship you your notebook back to the address you provided. It should arrive 5 - 7 days after your notebook has been digitized.";
    } else {
      return "We'll promptly recycle your notebook after it's been digitized. Don't worry, it will live forever digitally.";
    }

  }.property('controllers.digitizeScan.handleMethod')
});
