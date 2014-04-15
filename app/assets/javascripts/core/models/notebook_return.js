Core.NotebookReturn = Ember.Object.extend({
  form: function() {
    var action = window.ENV.STORE_ENDPOINT + "/cart/add";
    var variant = window.ENV.NOTEBOOK_RETURN_VARIANT_ID;

    var $input = $('<input>').attr({
      'type': 'hidden',
      'name': 'id',
      'value': variant
    });

    var $form = $('<form>').attr({
      'action': action,
      'target': '_blank',
      'method': 'POST'
    })

    $form.append($input);
    return $form;
  },

  submit: function() {
    this.form().submit();
  }
});
