$(document).ready(function () {
  $('body').on('click', '.delete_user', function (event) {
    event.preventDefault();
    var footer = new AppElement($(this).closest('.modal-footer'));
    footer.default_loading_gif();
    $.ajax({
      type: $(this).attr('data-method'),
      url: $(this).attr('href'),
      dataType: 'json',
      success: function (response) {
        toastr[response.status](response.message);
        if (response.status == 'success') {
          footer.app_element.closest('tr').fadeOut();
        }
      },
      complete: function () {
        footer.reset();
        $('.modal').modal('hide');
      }
    });
    return false;
  });

  $('body').on('submit', '.update_user', function (event) {
    event.preventDefault();
    var $self = $(this);
    var $form_object = new Form($self);
    var $button = new AppElement($self.find('.modal-footer').first());

    var start = function () {
      $button.default_loading_gif();
      $form_object.clear_error();
    };
    var success = function (response) {
      $('.modal-update-user').modal('hide');
      $('.modal-backdrop').remove();
      $button.app_element.closest('tr').replaceWith(response.html)
        .hide().fadeIn('normal');
    };
    var error = function (response) {
      $form_object.bootstrap_show_error('user', response.errors);
      $form_object.clear_password_field();
    };
    var complete = function () {
      $button.reset();
    };

    new AjaxFormRequest('json', $form_object)
      .request(start, success, null, error, complete, false);
  });

  $('.reset-button, .cancel-button').click(function () {
    var form = new Form($(this).closest('form'));
    form.undo_input('user', 'get', form.element.attr('action'));
  });
});
