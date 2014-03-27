App.TouchViewerPaneController = Ember.ObjectController.extend({
  needs: ['touchViewer'],
  load: false,

  shouldLoad: function() {
    var curIndex = this.get('controllers.touchViewer.currentSlide');
    var modelIndex = this.get('model.index');
    var load = (curIndex === modelIndex || curIndex === modelIndex - 1 || curIndex === modelIndex + 1);
    this.set('load', load);
  }.observes('controllers.touchViewer.currentSlide').on('init')
});
