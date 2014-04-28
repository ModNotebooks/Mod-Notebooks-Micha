App.DigitizeScanController = Ember.Controller.extend({
  needs: ['digitize', 'digitizeCode', 'digitizeAddress'],

  handleMethod: '1',
  completed: false,

  radioContent: [
    { label: 'Recycle my notebook (free)', value: '1' },
    { label: 'Recycle & send me a new one', value: '2' },
    { label: 'Send it back to me (+$10)', value: '3' },
  ],

  actions: {
    advance: function() {
      var handleMethod = this.get('handleMethodName');
      this.set('completed', true);

      if (handleMethod === 'return') {
        this.transitionToRoute('digitize.address');
      } else {
        this.get('controllers.digitizeAddress').set('completed', true);
        this.transitionToRoute('digitize.confirmation');
      }
    },
  },

  handleMethodName: function() {
    var handleMethod = this.get('handleMethod');

    if (handleMethod === '3') {
      return "return";
    } else {
      return  "recycle";
    }
  }.property('handleMethod')

});
