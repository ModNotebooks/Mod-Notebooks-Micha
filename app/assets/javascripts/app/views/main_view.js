App.MainView = Ember.View.extend({
  classNames: ['l-app-main'],

  noScroll: function() {
    $(document.documentElement).toggleClass('no-scroll', this.get('controller.settingsVisible'));
  }.observes('controller.settingsVisible')
});
