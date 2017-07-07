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
    var success = function () {
      $self.closest('.modal-update-post').modal('hide');
      update_post_real_time($self);
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
});

function update_post_real_time(form) {
  var post_title = form.find('#post_title').val();
  var post_content = form.find('#post_content').val();
  var post_area = form.closest('.post-item');
  post_area.find('.time-ago a').text('Updated less than a minute ago')
    .hide().fadeIn('slow');
  post_area.find('.post_title').html(post_title).hide().fadeIn('slow');
  post_area.find('.post_content').html(post_content).hide().fadeIn('slow');
}
