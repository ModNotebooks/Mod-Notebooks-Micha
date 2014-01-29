Settings.ApplicationView = Ember.View.extend({
  templateName: 'application-settings',
  tagName: 'main',
  classNames: ['l-settings'],
  classNameBindings: ['controller.isVisible:is-visible']
});
