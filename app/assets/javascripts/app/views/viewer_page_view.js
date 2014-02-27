App.ViewerPageView = Ember.View.extend({
  isError: false,
  isLoading: true,

  didInsertElement: function() {
    this.$('img.viewer__image')
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
