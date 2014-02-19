App.DigitizeScanController = Ember.ObjectController.extend({
  needs: ['digitize', 'digitizeCode'],

  handleMethod: null,
  completed: false,

});
