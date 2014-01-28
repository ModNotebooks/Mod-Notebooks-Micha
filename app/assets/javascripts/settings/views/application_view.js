Settings.ApplicationView = Ember.View.extend({
  tagName: 'main',
  classNames: ['l-settings'],
  classNameBindings: ['controller.isVisible:is-visible']
});
