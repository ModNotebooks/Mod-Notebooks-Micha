App.DigitizeScanController = Ember.ObjectController.extend({
  needs: ['digitize', 'digitizeCode'],

  handleMethod: '1',
  completed: false,

  radioContent: [
    { label: 'Recycle my notebook', value: '1' },
    { label: 'Recycle & send me a new one', value: '2' },
    { label: 'Send it back to me (+$10)', value: '3' },
  ],

  actions: {
    advance: function() {
      var handleMethod = this.get('handleMethod');
      this.set('hasCompleted', true);

      if (handleMethod === '2' || handleMethod === '3') {
        this.transitionToRoute('digitize.address');
      } else {
        this.controllerFor('digitize.address').set('hasCompleted', true);
        this.transitionToRoute('digitize.comfirmation');
      }
    },
  },

});
