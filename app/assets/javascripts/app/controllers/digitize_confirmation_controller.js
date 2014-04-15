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
          _this.transitionToRoute('notebooks');

          if (notebook.get('handleMethod') === 'return') {
            Core.NotebookReturn.create().submit();
          } else if (handleMethod === "2") {
            window.open(window.ENV.STORE_ENDPOINT + '#order');
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

  heading: function() {
    var handleMethod = this.get('controllers.digitizeScan.handleMethod');

    switch (handleMethod) {
      case "1":
        return "Recycle my notebook";
      case "2":
        return "Recycle & send me a new one";
      case "3":
        return "Send it back to me";
      default:
        return "Confirmation";
    }
  }.property('controllers.digitizeScan.handleMethod'),

  stepOne: function() {
    return "Place your notebook inside the envelope that's inside the backpage flap, and mail it back to us using the pre-paid label";
  }.property(),

  stepTwo: function() {
    return "We'll receive your notebook in 5 days.";
  }.property(),

  stepThree: function() {
    return "Our team will scan, digitize, and upload your notebook file to your account. We'll notify you then when it's read";
  }.property(),

  stepFour: function() {
    var handleMethod = this.get('controllers.digitizeScan.handleMethod');
    return "Copy for handle method #" + handleMethod;
  }.property('controllers.digitizeScan.handleMethod')
});
