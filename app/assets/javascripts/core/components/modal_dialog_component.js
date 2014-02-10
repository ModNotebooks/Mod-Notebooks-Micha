Core.ModalDialogComponent = Ember.Component.extend({
  actions: {
    close: function() {
      this.animateOut().then(this.sendAction.bind(this));
    }
  },

  eventManager: Ember.Object.create({
    click: function(evt, view) {
      if (view.$(evt.target).hasClass('modal__center')) {
        view.send('close');
      }
    }
  }),

  didInsertElement: function() {
    var _this = this;
    this.sendAction('change', true);

    Ember.run.later(function() {
      _this.$().addClass('is-visible');
    }, 100);
  },

  animateOut: function() {
    var _this = this;

    return new Ember.RSVP.Promise(function(resolve) {
      _this.sendAction('change', false);
      _this.$().removeClass('is-visible').one(Core.utils.transitionEnd, function() {
        resolve();
      });
    });
  },

  willDestroyElement: function() {
    Ember.$(document.documentElement).removeClass('no-scroll');
  }
});
