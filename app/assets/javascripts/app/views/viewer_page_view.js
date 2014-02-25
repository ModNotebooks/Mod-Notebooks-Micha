App.ViewerPageView = Ember.View.extend({
  isError: false,
  isLoading: true,

  didInsertElement: function() {
    this.$('img')
      .one('load', this.imageLoaded.bind(this))
      .one('error', this.imageError.bind(this));
  },

  imageLoaded: function() {
    this.set('isLoading', false);
  },

  imageError: function() {
    this.set('isLoading', false);
    this.set('isError', true);
  }
});
