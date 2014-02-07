Core.ModalDialogComponent = Ember.Component.extend({
  actions: {
    close: function() {
      this.animateOut().then(this.sendAction.bind(this));
    }
  },

  eventManager: Ember.Object.create({
    click: function(evt, view) {
      if (view.$(evt.target).hasClass('modal__content')) {
        view.send('close');
      }
    }
  }),

  didInsertElement: function() {
    var _this = this;
    Ember.$(document.documentElement).addClass('no-scroll');
    Ember.$('.l-app-content').addClass('modal-open');

    Ember.run.later(function() {
      _this.$().addClass('is-visible');
    }, 100);
  },

  animateOut: function() {
    var _this = this;

    return new Ember.RSVP.Promise(function(resolve) {
      Ember.$('.l-app-content').removeClass('modal-open');
      _this.$().removeClass('is-visible').one(Core.utils.transitionEnd, function() {
        resolve();
      });
    });
  },

  willDestroyElement: function() {
    Ember.$(document.documentElement).removeClass('no-scroll');
  }
});
