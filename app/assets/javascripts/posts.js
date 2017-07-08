$(document).ready(function () {
  $('body').on('submit', '#new_post', function (event) {
    event.preventDefault();
    var $self = $(this);
    var $form_object = new Form($self);
    var $button = new AppElement($self.find('.modal-footer'));

    var start = function () {
      $button.default_loading_gif();
      $form_object.clear_error();
    };
    var success = function (response) {
      $(response.html).prependTo('.body-posts-area').hide().fadeIn('slow');
      $('.modal').modal('hide');
      $('.modal').hide();
      $form_object.clear_input();
      increase_posts_size();
      $('select').tagsinput('removeAll');
    };
    var error = function (response) {
      $form_object.bootstrap_show_error('post', response.errors);
    };
    var complete = function () {
      $button.reset();
    };

    new AjaxFormRequest('json', $form_object)
      .request(start, success, null, error, complete, true);
  });

  $('body').on('click', '.delete-post', function (event) {
    event.preventDefault();
    var button = $(this);
    var $footer = new AppElement(button.closest('.modal-footer'));
    $footer.default_loading_gif();
    $.ajax({
      type: button.attr('data-method'),
      url: button.attr('href'),
      dataType: 'json',
      success: function (response) {
        if (response.status == 'success') {
          toastr[response.status](response.message);
          decrease_posts_size();
        }
        else {
          toastr['error']('You have something error!');
        }
      },
      complete: function () {
        $footer.reset();
        $footer.app_element.closest('.post-item').fadeOut('normal');
        $('.modal').modal('hide');
      }
    });
    return false;
  });

  $('body').on('submit', '.update_post', function (event) {
    event.preventDefault();
    var $self = $(this);
    var $form_object = new Form($self);
    var $footer = new AppElement($self.find('.modal-footer').first());
    var start = function () {
      $footer.default_loading_gif();
      $form_object.clear_error();
    };
    var success = function (response) {
      $self.closest('.post-item').replaceWith(response.html).hide().fadeIn('normal');
      $('.modal-update-post').modal('hide');
      $('.modal-backdrop').remove();
      $('select').tagsinput('removeAll');
    };

    var error = function (response) {
      $form_object.bootstrap_show_error('post', response.errors);
      $form_object.clear_password_field();
    };
    var complete = function () {
      $footer.reset();
    };

    new AjaxFormRequest('json', $form_object)
      .request(start, success, null, error, complete, true);
  });

  $('body').on('click', '.cancel-edit-post', function () {
    var form = new Form($(this).closest('form'));
    form.clear_error();
    form.undo_input('post', 'get', form.element.attr('action'));
  });

  $('input[name="post[lists_tag][]"]').remove();
});

function increase_posts_size() {
  $('.posts-size').each(function () {
    $(this).text(parseInt($(this).text()) + 1);
  });
}

function decrease_posts_size() {
  $('.posts-size').each(function () {
    $(this).text(parseInt($(this).text()) - 1);
  });
}
