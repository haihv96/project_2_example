$(document).ready(function () {
  $.ajaxSetup({
    headers: {
      'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
    }
  });
  $('.alert').delay(6000).slideUp(200, function () {
    $(this).alert('close');
  });
  reloadTINYMCE('textarea');
});

toastr.options = {
  'closeButton': true,
  'debug': false,
  'positionClass': 'toast-bottom-right',
  'onclick': null,
  'showDuration': '1000',
  'hideDuration': '1000',
  'timeOut': '5000',
  'extendedTimeOut': '1000',
  'showEasing': 'swing',
  'hideEasing': 'linear',
  'showMethod': 'fadeIn',
  'hideMethod': 'fadeOut'
};

function reloadTINYMCE(){
  tinyMCE.EditorManager.editors = [];
  tinyMCE.init({
    selector: 'textarea.tinymce'
  });
}

var AppElement = function (element) {
  this.app_element = element;
  this.html = element.html();

  this.loading = function (html_append) {
    this.app_element.html(html_append);
    this.disable();
  };

  this.disable = function () {
    this.app_element.prop('disabled', true);
  };

  this.enable = function () {
    this.app_element.prop('disabled', false);
  };

  this.reset = function () {
    this.app_element.html(this.html);
    this.enable();
  };

  this.default_loading = function () {
    this.app_element.html('<i class="fa fa-spinner fa-spin"></i> ' +
      'Loading...');
    this.disable();
  };

  this.only_icon_loading = function () {
    this.app_element.html('<i class="fa fa-spinner fa-spin"></i>');
    this.disable();
  };

  this.default_loading_gif = function () {
    this.app_element.html('<img width="40px" src="/assets/gif/loading.gif">');
    this.disable();
  };

  this.loading_area = function () {
    this.app_element.append('<div class="loading-area-background"></div> ' +
      '<div class="loading-area"></div>');
  };

  this.remove_loading_area = function () {
    this.app_element.find('.loading-area-background').remove();
    this.app_element.find('.loading-area').remove();
  };
};

var Form = function (form) {
  this.element = form;

  this.method = function () {
    var method = null;
    if (this.element.attr('method').length) {
      method = this.element.attr('method');
    } else {
      method = this.element.children('input[name="_method"]').val();
    }
    return method;
  };

  this.params = function () {
    return this.element.serialize();
  };

  this.action = function () {
    return this.element.attr('action');
  };

  this.clear_error = function () {
    this.element.find('.form-group').removeClass('has-error');
    this.element.find('span.error-class').remove();
    this.element.find('div.error-class').remove();
  };

  this.bootstrap_show_error = function (model, error_messages) {
    var number_errors = 0;
    var form_element = this.element;
    $.each(error_messages, function (key, values) {
      var input_element = form_element.find('#' + model + '_' + key);
      input_element.closest('.form-group').addClass('has-error');
      input_element.closest('.form-group').find('label')
        .addClass('help-block error-class');
      $.each(values, function (index, value) {
        number_errors++;
        input_element.after('<span class="help-block error-class">' +
          '<div>' + key.replace('_', ' ') + ' field ' + value + '</div> ' +
          '</span>');
      });
    });
    form_element.find('.form-group').first().before('' +
      '<div class="alert alert-danger fade in alert-dismissable error-class">' +
      ' <a href="#" class="close" data-dismiss="alert" ' +
      'aria-label="close" title="close">×' +
      '</a>you have <strong>' + number_errors + ' errors</strong> </div>');
  };

  this.clear_password_field = function () {
    this.element.find('input[type="password"]').val(null);
  };

  this.clear_input = function () {
    this.element.find('input').val(null);
    if (tinyMCE.activeEditor != null) {
      tinyMCE.activeEditor.setContent('');
    }
  };

  this.undo_input = function (form_for_model, method, url_ajax) {
    var form_element = this.element;
    $.ajax({
      type: method,
      url: url_ajax,
      data: {get_data_only: true},
      dataType: 'json',
      success: function (response) {
        if (response.status == 'success') {
          $.each(response.object, function (key, value) {
            var input = form_element.find('#' + form_for_model + '_' + key);
            if (input.prop('tagName') == 'TEXTAREA') {
              tinyMCE.activeEditor.setContent(value);
            } else {
              input.val(value);
            }
          });
        }
      }
    });
    return false;
  };
};

var AjaxFormRequest = function (datatype, form_object) {
  this.datatype = datatype;

  this.request = function (start, success, warning, error, complete, show_notice) {
    start();
    $.ajax({
      type: form_object.method(),
      url: form_object.action(),
      data: form_object.params(),
      dataType: this.datatype,
      success: function (response) {
        if (show_notice) {
          toastr[response.status](response.message);
        }
        switch (response.status) {
        case 'success':
          if (success != null) {
            success(response);
          }
          break;
        case 'warning':
          if (warning != null) {
            warning(response);
          }
          break;
        default:
          if (error != null) {
            error(response);
          }
        }
      },
      complete: function (response) {
        complete(response);
      }
    });
    return false;
  };
};
