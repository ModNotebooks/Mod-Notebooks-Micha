App.DigitizeConfirmationController = Ember.ObjectController.extend({
  needs: ['digitize', 'digitizeCode', 'digitizeScan'],

  isLoading: false,
  handleMethod: null,

  actions: {
    submit: function() {
      var notebookIdentifier = this.get('controllers.digitizeCode.code');
      var handleMethod       = this.get('controllers.digitizeScan.handleMethodName');

      if (notebookIdentifier && handleMethod) {
        var notebook = thie.get('content');

        notebook.setProperties({
          'notebookIdentifier': notebookIdentifier,
          'handleMethod': handleMethod
        });

        notebook.save().then(function() {
          alert('SAVED!');
        }, function(err) {
          alert("FAILED!");
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
