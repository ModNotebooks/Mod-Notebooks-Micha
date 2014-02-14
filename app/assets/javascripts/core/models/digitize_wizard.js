Core.DigitizeWizard = Ember.Object.extend({
  curStep: 0,
  steps: ['join', 'code', 'scan', 'address', 'confirm'],

  advance: function() {
    if (this.get('curStep') < this.get('totalSteps').length) {
      this.incrementProperty('curStep');
      return true;
    } else {
      return false;
    }
  },

  currentStep: function() {
    return this.get('totalSteps')[this.get('curStep')];
  },

  hasCompletedStep: function(step) {
    return this.get('curStep') > step;
  }
});
