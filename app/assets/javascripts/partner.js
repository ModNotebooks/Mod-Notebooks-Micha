// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require blueimp-tmpl/js/tmpl
//= require jquery-file-upload/js/vendor/jquery.ui.widget
//= require jquery-file-upload/js/jquery.iframe-transport
//= require jquery-file-upload/js/jquery.fileupload
//= require jquery_ujs
//= require underscore/underscore
//= require spectrum/spectrum
//= require_tree ./partner
//= require_self

(function() {

  // Setup Color Inputs
  $('input[type=color]').spectrum({
    showInput: true,
    allowEmpty:true
  });

  $(document).ready(function() {
    $('.js-search-toggle').on('click', function() {
      $('.js-upload-tool').hide();
      $('.js-search-tool').show();
      $(this).hide();
      $('.js-upload-toggle').show();
    });

    $('.js-upload-toggle').on('click', function() {
      $('.js-search-tool').hide();
      $('.js-upload-tool').show();
      $(this).hide();
      $('.js-search-toggle').show();
    });
  });

  $(document).ready(function() {

    var $upload = $('.js-pdf-upload').fileupload({
      acceptFileTypes: /(\.|\/)(pdf)$/i,

      submit: function(e, data) {
        var $this = $(this);

        var upload = new NotebookUpload(data, $this);
        upload.submit().fail(function() {
          upload.abort();
        });

        return false;
      }
    });

    $upload.on('fileuploadadd', function (e, data) {
      var $form = data.form;
      data.notebookIdentifier = $.trim( $form.find("[name=notebook_identifier]").val() );
      data.context = $(tmpl("tmpl-upload", data)).appendTo('#files')

      $('.js-cancel-button').on('click', function() {
        data.abort();
        data.context.remove();
      });
    });

    $upload.on('fileuploadprogress', function(e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10).toString() + "%";
      $('.js-upload-progress', data.context).text(progress);
      $('.js-upload-progressbar', data.context).css('width', progress);
    });

    $upload.on('fileuploaddone', function(e, data) {
      $('.js-upload-progress', data.context).html("&#10003; Done");
      $('.js-upload-progressbar', data.context).css('width', '100%');
      data.context.addClass('is-done');

      setTimeout(function() {
        data.context.remove();
      }, 4000);
    });

    $upload.on('fileuploadfail', function(e, data) {
      var error = "Error occurred",
          status = data.jqXHR ? data.jqXHR.status : 404;

      switch(status) {
      case 404:
        error = "Notebook could not be found or has not been submitted by a user.";
        break;
      case 422:
        error = "Something is wrong with the PDF or the notebook has not been submitted by a user.";
        break;
      case 500:
        error = "Something is wrong on our end. Let us know.";
        break;
      }

      data.context.addClass('is-error');
      $('.js-upload-progress', data.context).text(error);
      $('.js-upload-progressbar', data.context).css('width', '0%');
    });

  });

}());
