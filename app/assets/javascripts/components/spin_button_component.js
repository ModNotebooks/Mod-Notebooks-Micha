App.SpinButtonComponent = Ember.Component.extend({
  buttonText: "Send",
  actions: {
    isLoading: false,
    showLoading: function() {
      if(!this.get('isLoading')){
        this.set('isLoading', true);
        this.sendAction('action');
      }
    }
  }
});
