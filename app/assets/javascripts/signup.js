$(document).ready(function () {
  $('#new_user').submit(function (event) {
    event.preventDefault();
    var form = $(this);
    var params = form.serialize();
    var submit_button = form.find('#submit_new_user');
    var old_html_submit_button = submit_button.html();

    form_clear_errors();
    button_loading_style(submit_button);
    var method = method_form(form);
    $.ajax({
      type: method,
      url: form.attr('action'),
      data: params,
      dataType: 'json',
      success: function (response) {
        if (response.status == 'success') {
          window.location.replace(response.redirect_to);
        } else {
          page_notice_custom_error()
          form_has_errors(form,'user',response.errors)
        }
      },
      error: function (xhr, ajaxOptions, thrownError) {
        console.log('error...', xhr);
      },
      complete: function () {
        reset_button(submit_button, old_html_submit_button);
        password_field_empty();
      }
    });
    return false;
  });
});
