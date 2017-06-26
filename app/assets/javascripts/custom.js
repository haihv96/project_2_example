$(document).ready(function () {
  $.ajaxSetup({
    headers: {
      'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
    }
  });
});
function button_loading_style(button_element) {
  button_element.html('<span class='
    + '"glyphicon glyphicon-refresh glyphicon-refresh-animate"'
    + '></span> Loading...');
  button_element.prop('disabled', true);
}

function reset_button(button_element, old_button_element_html) {
  button_element.html(old_button_element_html);
  button_element.prop('disabled', false);
}

function form_has_errors(form_element, model, error_messages) {
  var number_errors = 0;
  $.each(error_messages, function (key, values) {
    var input_element = form_element.find('#' + model + '_' + key);
    input_element.closest('.form-group').addClass('has-error');
    $.each(values, function (index, value) {
      number_errors++;
      input_element.after('<span class="help-block error-class">' +
        '<p>' + key.replace('_', ' ') + ' field ' + value + '</p> ' +
        '</span>');
    });
  });
  form_element.find('.form-group').first().before('' +
    '<div class="alert alert-danger fade in alert-dismissable error-class">' +
    ' <a href="#" class="close" data-dismiss="alert" ' +
    'aria-label="close" title="close">×' +
    '</a>you have <strong>' + number_errors + ' errors</strong> </div>');
}

function form_clear_errors() {
  $('.form-group').removeClass('has-error');
  $('.error-class').remove();
}

function password_field_empty() {
  $('input[type="password"]').val(null);
}

function method_form(form_element) {
  if ($(form_element).attr('method').length) {
    var method = $(form_element).attr('method');
  } else {
    var method = $(form_element).children('input[name="_method"]').val();
  }
  return method;
}

function page_notice(type, message) {
  toastr[type](message);
}

function page_notice_custom_error() {
  page_notice('error', 'You have somthing error!');
}

function page_notice_custom_success() {
  page_notice('error', 'Successful!');
}


function reset_form(form_element, form_for_model, method, url_ajax) {
  $.ajax({
    type: method,
    url: url_ajax,
    data: {
      get_data_only: true,
    },
    dataType: 'json',
    success: function (response) {
      if (response.status == 'success') {
        $.each(response.object, function (key, value) {
          form_element.find('#' + form_for_model + '_' + key).val(value);
        });
      }
    },
    error: function (xhr, ajaxOptions, thrownError) {
      console.log('error...', xhr);
    },
    complete: function () {
    }
  });
  return false;
}

function loading(element) {
  element.html('<img src="/assets/gif/loading.gif", height="30px">');
}


toastr.options = {
  "closeButton": true,
  "debug": false,
  "positionClass": "toast-bottom-right",
  "onclick": null,
  "showDuration": "1000",
  "hideDuration": "1000",
  "timeOut": "5000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}
