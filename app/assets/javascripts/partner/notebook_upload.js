window.NotebookUpload = (function() {

  var Upload = function(data, $upload) {
    this.data = data;
    this.$upload = $upload;
  };

  Upload.prototype._valid = function() {
    if (this.notebookIdentifier() === "") {
      return false;
    }

    return true;
  };

  Upload.prototype._formData = function() {
    var options = { dataType: 'json', cache: false, method: 'GET' };
    return $.ajax('/uploads/form', options);
  };

  Upload.prototype._normalizeFormData = function(data, modelData) {
    data.key = this._key(data.key, modelData.id);
    delete data.action;
    return data;
  };

  Upload.prototype._modelData = function () {
    var notebookIdentifier = this.notebookIdentifier();
    var url = "/notebooks/" + notebookIdentifier + '.json';
    var options = { method: 'GET' };
    return $.ajax(url, options);
  };

  Upload.prototype._key = function (serverKey, id) {
    var parts = serverKey.split('/');
    parts.pop();
    parts[3] = id;
    parts[parts.length - 1] = _.last(parts) + ".pdf";

    return parts.join('/');
  };

  Upload.prototype.notebookIdentifier = function (first_argument) {
    return $.trim(this.data.form.find('[name=notebook_identifier]').val());
  };

  Upload.prototype.submit = function() {
    var _this = this;
    var deferred = $.Deferred();

    if (!this._valid()) {
      setTimeout(function() {
        deferred.reject();
      }, 1);

      return deferred.promise();
    }

    this._formData().then(function(formData) {
      _this._modelData().then(function(resp) {
        var modelData = resp["notebook"];
        _this.data.url = formData.action;
        formData = _this._normalizeFormData(formData, modelData);

        _this.data.formData = formData;
        _this.$upload.fileupload('send', _this.data)
        _this.$upload.on('fileuploaddone', function ondone(e, data) {
          if (data.notebookIdentifier === _this.notebookIdentifier()) {
            var key = $(data.result).find('Key').text();
            _this.updateModel(modelData.id, key, deferred);
            _this.$upload.off('fileuploaddone', ondone);
          };
        });

      }, function(jqXHR, textStatus, errorThrown) {
        deferred.reject();
      });
    }, function(jqXHR, textStatus, errorThrown) {
      deferred.reject();
    });

    return deferred.promise();
  };

  Upload.prototype.updateModel = function (id, filepath, deferred) {
    var url = "/notebooks/" + id + "/upload.json";
    var filename = _.last(filepath.split('/'));
    return $.post(url, { notebook: { pdf: filename }} ).then(function() {
      deferred.resolve();
    }, function() {
      deferred.reject();
    });
  };

  Upload.prototype.abort = function() {
    this.data.abort();
  };

  return Upload;

}());
