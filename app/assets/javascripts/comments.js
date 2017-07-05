$(document).ready(function () {
  $('body').on('submit', '.new_comment', function (event) {
    request_ajax(event, $(this));
  });

  $('body').on('keydown', '.comment-area', function (event) {
    var form = $(this).closest('form');
    if (form.find('#enter_to_comment').prop('checked') &&
      event.keyCode == 13 && !event.shiftKey
    ) {
      request_ajax(event, form);
    }
  });

  $('body').on('click', '.delete-comment', function () {
    var button = $(this);
    $.ajax({
      type: button.attr('data-method'),
      url: button.attr('href'),
      dataType: 'json',
      success: function (response) {
        if (response.status == 'success') {
          button.closest('.comment-item').slideUp('normal');
        }
      },
      complete: function () {
        $('.modal').modal('hide');
      }
    });
    return false;
  });

  $('body').on('submit', '.edit_comment', function (event) {
    event.preventDefault();
    var $form = $(this);
    var $button = new AppElement($form.find('.update_comment'));
    var $form_object = new Form($form);

    var start = function () {
      $button.default_loading();
      $form_object.clear_error();
    };
    var success = function () {
      update_comment_real_time($form);
    };
    var error = function () {
      $form_object.bootstrap_show_error();
    };
    var complete = function () {
      $button.reset();
    };
    new AjaxFormRequest('json', $form_object)
      .request(start, success, null, error, complete, false);
  });

  $('body').on('click', '.edit_comment_button', function () {
    var button = $(this);
    $.ajax({
      type: 'get',
      url: $(this).attr('data'),
      dataType: 'json',
      success: function (response) {
        button.closest('.media-body')
          .find('.cmt-body').html(response.html).hide().fadeIn('normal');
      }
    });
  });

  $('body').on('click', '.cancel-edit-comment', function (event) {
    event.preventDefault();
    var form_element = $(this).closest('form');
    new Form(form_element).clear_error();
    get_data(form_element, 'comment', 'get', form_element.attr('action'));
  });

  $('body').on('click', '.comment-add', function () {
    $(this).closest('.panel-body').next().slideToggle('fast');
  });

  $('body').on('click', '.comment-area-reset', function () {
    $(this).closest('.panel-update-comment').slideToggle('fast');
  });
});

function request_ajax(event, form) {
  event.preventDefault();
  var $form = form;
  var $form_object = new Form($form);
  var $button = new AppElement($form.find('.submit-new-comment'));
  var start = function () {
    $button.default_loading();
  };
  var success = function (response) {
    $(response.html).prependTo($form.closest('.post-item')
      .find('.comments-area'))
      .hide().fadeIn('normal');
  };
  var error = function (response) {
    if (response.message) {
      toastr[response.status](response.message);
    }
  };
  var complete = function () {
    $form.find('.comment-area').first().val('');
    $button.reset();
  };
  new AjaxFormRequest('json', $form_object)
    .request(start, success, null, error, complete, false);
}

function update_comment_real_time(form) {
  form.closest('.media-body').find('.time-comment')
    .text('Updated less than a minute ago').hide().fadeIn('slow');
  replace_form(form);
}

function replace_form(form) {
  var html_body = form.find('#comment_content').val();
  form.closest('.media-body').find('.cmt-body')
    .html(html_body).hide().fadeIn('slow');
}

function get_data(form_element, form_for_model, method, url_ajax) {
  $.ajax({
    type: method,
    url: url_ajax,
    data: {get_data_only: true},
    dataType: 'json',
    success: function (response) {
      if (response.status == 'success') {
        $.each(response.object, function (key, value) {
          form_element.find('#' + form_for_model + '_' + key).val(value);
        });
      }
      replace_form(form_element);
    }
  });
}
