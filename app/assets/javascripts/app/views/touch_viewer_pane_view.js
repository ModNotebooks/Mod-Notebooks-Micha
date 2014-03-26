App.TouchViewerPaneView = Ember.View.extend({
  templateName: 'touch_viewer_pane',
  classNames: ['touchviewer__pane'],
  loaded: false,

  imageSrc: function() {
    if (this.get('controller.load') || this.get('loaded')) {
      this.set('loaded', true);
      return this.get('context.image').large;
    } else {
      return ""
    }
  }.property('controller.load')
});
