(function() {

  var forEach = [].forEach;
  var units   = ['vw', 'vh', 'vm'];

  ////////////////////////////////////////////

  var Processor = {
    process: function(css) {
      if (!css) return;
      var w = innerWidth, h = innerHeight, m = Math.min(w,h);

      return css.replace(RegExp('\\b(\\d+)(' + units.join('|') + ')\\b', 'gi'), function($0, num, unit) {
        switch (unit) {
          case 'vw':
            return (num * w / 100) + 'px';
          case 'vh':
            return num * h / 100 + 'px';
          case 'vm':
            return num * m / 100 + 'px';
        }
      });
    }
  };

  ////////////////////////////////////////////

  var SheetFetcher = {
    fetch: function(url, done) {
      var _this = this;
      var callback = done;
      var xhr = new XMLHttpRequest();

      var done = function() {
        var css = xhr.responseText;
        if (css && (!xhr.status || xhr.status < 400 || xhr.status > 600)) {
          callback && css && callback(css);
        }
      };

      xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
          done();
        }
      };

      try {
        xhr.open('GET', url);
        xhr.send(null);
      } catch (e) {
        // Fallback to XDomainRequest if available
        if (typeof XDomainRequest != "undefined") {
          xhr = new XDomainRequest();
          xhr.onerror = xhr.onprogress = function() {};
          xhr.onload = function() {
            if (!xhr.status || xhr.status < 400 || xhr.status > 600) {
              process(xhr.responseText);
            }
          };
          xhr.open("GET", url);
          xhr.send(null);
        }
      }
    }
  };

  ////////////////////////////////////////////

  var Sheet = function(css) {
    this.styleEl      = null;
    this.attached     = false;
    this.css          = css;
    this.processedCSS = this.process();
  };

  Sheet.prototype.process = function() {
    return Processor.process(this.css);
  };

  Sheet.prototype.refresh = function() {
    this.processedCSS = this.process();
    this.inject();
  }

  Sheet.prototype.inject = function() {
    var style = this.attachStyleElement();
    style.textContent = this.processedCSS;
  };

  Sheet.prototype.styleElement = function() {
    this.styleEl = this.styleEl || document.createElement('style');
    return this.styleEl;
  };

  Sheet.prototype.attachStyleElement = function() {
    if (!this.attached) {
      this.attached = true;
      document.head.appendChild(this.styleElement());
    }

    return this.styleElement();
  };

  ///////////////////////////////////////
  // http://stackoverflow.com/questions/4817029/whats-the-best-way-to-detect-a-touch-screen-device-using-javascript
  var shouldInit = 'ontouchstart' in window || navigator.msMaxTouchPoints;

  if (shouldInit) {
    forEach.call(document.styleSheets, function(s) {
      var url = s.href;

      if (!url.match(/\/assets\//i)) return;

      SheetFetcher.fetch(s.href, function(css) {
        var sheet = new Sheet(css);
        sheet.inject();

        window.addEventListener('orientationchange', function() {
          sheet.refresh();
        }, true);
      });
    });
  }

}());
