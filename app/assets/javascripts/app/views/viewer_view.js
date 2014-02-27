// App.ViewerView = Ember.View.extend({
//   classNames: ['viewer'],

//   didInsertElement: function() {
//     $(document).on('keyup', Ember.$.proxy(this.onKeyUp, this));
//   },

//   onKeyUp: function(event) {
//     var key = event.which;
//     if (key === 37) {
//       this.get('controller').send('previous');
//     } else if (key === 39) {
//       this.get('controller').send('next');
//     }
//   },

//   willDestroyElement: function() {
//     $(document).off('keyup', this.onKeyUp);
//   }
// });
