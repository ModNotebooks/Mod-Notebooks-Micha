Ember.Application.initializer({
  name: 'tween',
  initialize: function(container, application) {
    (function animate() {
      requestAnimationFrame(animate);
      TWEEN.update();
    }());
  }
});
