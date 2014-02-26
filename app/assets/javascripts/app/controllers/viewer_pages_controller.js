App.ViewerPagesController = Ember.ArrayController.extend({
  needs: ['viewer'],
  sortProperties: ['index'],
  sortAscending: true,

  actions: {
    previous: function() {
      var left     = this.get('content.firstObject'),
          right    = this.get('content.lastObject'),
          pages    = this.get('controllers.viewer.content'),
          notebook = this.get('controllers.viewer.notebook');

      if ((left && left.get('isFirstPage')) || (right && right.get('isFirstPage'))) {
        return;
      } else if(left) {
        var index = left.get('previousPage.index');
        var previousPage = pages.findBy('index', index);
        this.transitionToRoute('viewer.pages', notebook.id, previousPage);
      }
    },

    next: function() {
      var left     = this.get('content.firstObject'),
          right    = this.get('content.lastObject'),
          pages    = this.get('controllers.viewer.content'),
          notebook = this.get('controllers.viewer.notebook');

      if ((left && left.get('isLastPage')) || (right && right.get('isLastPage'))) {
        return;
      } else if (right) {
        var index = right.get('nextPage.index');
        var nextPage = pages.findBy('index', index);
        this.transitionToRoute('viewer.pages', notebook.id, nextPage);
      }
    }
  }
});
