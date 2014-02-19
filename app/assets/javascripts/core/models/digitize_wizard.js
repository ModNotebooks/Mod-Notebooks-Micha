Core.DigitizeWizard = Ember.Object.extend({
  steps: ['auth', 'code', 'scan', 'address', 'confirm'],
  completedSteps: [],

  advance: function() {
    this.get('completedSteps').pushObject( this.get('steps').popObject() );
  },

  currentStep: function() {
    return this.get('steps').get('firstObject');
  }.property('steps', 'completedSteps'),

  hasCompletedStep: function(step) {
    return this.get('completedSteps').contains(step);
  }
});
