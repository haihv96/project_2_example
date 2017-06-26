$(document).ready(function () {
  $('body').on('submit', '.new_comment', function (event) {
    var form = $(this);
    request_ajax(event, form);
  });

  $('body').on('keydown', '.comment-area', function (event) {
    var form = $(this).closest('form');
    if (form.find('#enter_to_comment').prop('checked') &&
      event.keyCode == 13 && !event.shiftKey
    ) {
      request_ajax(event, form);
    }
  });

  $('body').on('click', '.delete-comment', function (event) {
    var confirm = window.confirm("Are you sure delete this comment ?");
    var button = $(this);
    if (confirm == false) {
      return false;
    }
    else {
      $.ajax({
        type: button.attr('data-method'),
        url: button.attr('href'),
        data: {},
        dataType: 'json',
        success: function (response) {
          if (response.status == 'success') {
            button.closest('.comment-item').fadeOut('normal');
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
  });

  $('body').on('submit', '.edit_comment', function (event) {
    event.preventDefault();
    var form = $(this);
    var params = form.serialize();
    clear_form_error();
    var button = form.find('.update_comment');
    var old_html_button = button.html();
    button_loading_style(button);
    $.ajax({
      type: form.children('input[name="_method"]').val(),
      url: form.attr('action'),
      data: params,
      dataType: 'json',
      success: function (response) {
        if (response.status == 'success') {
          update_comment_real_time(form);
        } else {
          // show errors from response to input element
          $.each(response.errors, function (key, values) {
            var input_attr_error = form.find("#comment_" + key);
            $.each(values, function (index, value) {
              add_error_input(input_attr_error, key, value);
            });
          });
        }
      },
      error: function (xhr, ajaxOptions, thrownError) {
        console.log('error...', xhr);
      },
      complete: function () {
        reset_button(button, old_html_button);
      }
    });
    return false;
  });

  $('body').on('click', '.edit_comment_button', function (event) {
    var button = $(this);
    $.ajax({
      type: 'get',
      url: $(this).attr('data'),
      data: {},
      dataType: 'json',
      success: function (response) {
        button.closest('.media-body')
          .find('.cmt-body').html(response.html).hide().fadeIn('normal');
      },
      error: function (xhr, ajaxOptions, thrownError) {
        console.log('error...', xhr);
      },
      complete: function () {
      }
    });
  });

  $('body').on('click', '.cancel-button', function (event) {
    var form_element = $(this).closest('form');
    clear_form_error();
    get_data(form_element, 'comment', 'patch', form_element.attr('action'));
    debugger
  });
});

function request_ajax(event, form) {
  event.preventDefault();
  var params = form.serialize();
  var method = method_form(form);
  var button_submit = form.find('#submit_new_comment');
  button_loading_style(button_submit);
  $.ajax({
    type: method,
    url: form.attr('action'),
    data: params,
    dataType: 'json',
    success: function (response) {
      if (response.status == 'success') {
        $(response.html).prependTo(form.closest('.post-item')
          .find('#show_comment'))
          .hide().fadeIn('normal');
      } else if (response.message) {
        page_notice(response.status, response.message);
      }
    },
    error: function (xhr, ajaxOptions, thrownError) {
      console.log('error...', xhr);
    },
    complete: function () {
      form.find('.comment-area').first().val('');
      reset_button(button_submit, 'Post comment')
    }
  });
  return false;
};

function update_comment_real_time(form) {

  form.closest('.media-body').find('.time-comment')
    .text('Updated less than a minute ago').hide().fadeIn('slow');
  replace_form(form, comment_context);
}

function replace_form(form) {
  var html_body = form.find('#comment_context').val();
  form.closest('.media-body').find('.cmt-body')
    .html(html_body).hide().fadeIn('slow');
}

function get_data(form_element, form_for_model, method, url_ajax) {
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
      replace_form(form_element);
    },
    error: function (xhr, ajaxOptions, thrownError) {
      console.log('error...', xhr);
    },
    complete: function () {
    }
  });
}
