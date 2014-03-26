App.TouchViewerPaneController = Ember.ObjectController.extend({
  needs: ['touchViewer'],
  load: false,

  shouldLoad: function() {
    var curIndex = this.get('controllers.touchViewer.currentSlide') + 1;
    this.set('load', curIndex >= this.get('model.index'));
  }.observes('controllers.touchViewer.currentSlide').on('init')
});
