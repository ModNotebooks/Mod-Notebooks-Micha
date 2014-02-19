App.DigitizeConfirmationController = Ember.ObjectController.extend({
  needs: ['digitize', 'digitizeCode', 'digitizeScan', 'digitizeAddress'],

  completed: false,
  handleMethod: null
});
