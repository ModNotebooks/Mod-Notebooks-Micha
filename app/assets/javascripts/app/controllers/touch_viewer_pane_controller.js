App.TouchViewerPaneController = Ember.ObjectController.extend({
  needs: ['touchViewer'],
  load: false,

  shouldLoad: function() {
    var curIndex = this.get('controllers.touchViewer.currentSlide') + 1;
    var isCurrentOrNext = curIndex >= (this.get('model.index') - 1);
    this.set('load', isCurrentOrNext);
  }.observes('controllers.touchViewer.currentSlide').on('init')
});
