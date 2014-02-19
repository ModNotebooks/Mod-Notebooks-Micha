App.DigitizeAddressController = Ember.ObjectController.extend({
  needs: ['digitize', 'digitizeScan'],

  completed: false,
  handleMethod: null
});
