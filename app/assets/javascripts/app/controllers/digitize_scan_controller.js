App.DigitizeScanController = Ember.ObjectController.extend({
  needs: ['digitize', 'digitizeCode'],

  handleMethod: '1',
  completed: false,

  radioContent: [
    { label: 'Recycle my notebook', value: '1', name: 'one', namePath: 'view.one.elementId' },
    { label: 'Recycle & send me a new one', value: '2', name: 'two', namePath: 'view.two.elementId' },
    { label: 'Send it back to me (+$10)', value: '3', name: 'three', namePath: 'view.three.elementId' },
  ]

});
