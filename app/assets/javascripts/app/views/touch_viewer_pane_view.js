App.TouchViewerPaneView = Ember.View.extend({
  isLoading: false,
  isError: false,
  templateName: 'touch_viewer_pane',
  classNames: ['touchviewer__pane'],
  loaded: false,
  startLoaded: false,

  imageSrc: function() {
    if (this.get('controller.load') || this.get('startLoaded')) {
      this.set('startLoaded', true);
      return this.get('context.image').large;
    } else {
      return ""
    }
  }.property('controller.load'),

  watchLoad: function() {
    if (this.get('controller.load') && !this.get('loaded')) {
      this.set('isLoading', true);

      this.$('img.touchviewer__pane__image')
        .one('load', this.imageLoaded.bind(this))
        .one('error', this.imageError.bind(this));
    }
  }.observes('imageSrc').on('didInsertElement'),

  imageLoaded: function() {
    this.set('loaded', true);
    this.set('isLoading', false);
  },

  imageError: function() {
    this.set('isLoading', false);
    this.set('isError', true);
  },
});
