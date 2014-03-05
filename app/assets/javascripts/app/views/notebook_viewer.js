App.NotebookViewerView = Ember.View.extend({
  classNames: ['viewer'],

  didInsertElement: function() {
    $(document).on('keyup', Ember.$.proxy(this.onKeyUp, this));
  },

  onKeyUp: function(event) {
    var key = event.which;
    if (key === 37) {
      this.get('controller').send('previous');
    } else if (key === 39) {
      this.get('controller').send('next');
    }
  },

  mouseEnter: function(event) {
    this.showNav();
  },

  mouseLeave: function(event) {
    this.hideNav();
  },

  showNav: function(loc) {
    this.$().addClass('is-interacted');
  },

  hideNav: function(loc) {
    this.$().removeClass('is-interacted');
  },

  willDestroyElement: function() {
    $(document).off('keyup', this.onKeyUp);
  }
})
