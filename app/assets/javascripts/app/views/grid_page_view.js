App.GridPageView = Ember.View.extend({
  isError: false,
  isLoading: true,

  didInsertElement: function() {
    this.watchLoad();
  },

  watchLoad: function() {
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
  },

  imageSrc: function() {
    var images = this.get('context.image');
    return window.devicePixelRatio > 1 ? images.small : images.thumb;
  }.property()
});
