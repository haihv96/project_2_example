$(document).ready(function () {
  $('body').on('submit', '#new_post', function (event) {
    event.preventDefault();
    var form = $(this);
    var params = form.serialize();
    var submit_button = form.find('#submit_new_post');
    var old_html_submit_button = submit_button.html();
    clear_error();
    button_loading_style(submit_button);
    var method = method_form(form);
    $.ajax({
      type: method,
      url: form.attr('action'),
      data: params,
      dataType: 'json',
      success: function (response) {
        page_notice(response.status, response.message)
        if (response.status == 'success') {
          clear_input(form);
          $(response.html).prependTo('#posts').hide().fadeIn(600);
          $('.modal-update-post').hide();
        } else {
          show_error(response.errors);
        }
      },
      error: function (xhr, ajaxOptions, thrownError) {
        console.log('error...', xhr);
      },
      complete: function () {
        reset_button(submit_button, old_html_submit_button);
      }
    });
    return false;
  });

  $('body').on('click', '.delete-post', function (event) {
    var confirm = window.confirm("Are you sure delete post?");
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
          page_notice(response.status, response.message);
          if (response.status == 'success') {
            button.closest('.post-item').fadeOut('normal');
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

  $('body').on('submit', '.update_post', function (event) {
    event.preventDefault();
    var form = $(this);
    var params = form.serialize();
    var modal_footer = form.find('.modal-footer').first();
    var all_modal = form.closest('.modal-update-post');
    var old_html_modal_footer = modal_footer.html();
    /* clear errors from input, icon loading */
    clear_form_error();
    loading(modal_footer);
    $.ajax({
      type: form.children('input[name="_method"]').val(),
      url: form.attr('action'),
      data: params,
      dataType: 'json',
      success: function (response) {
        page_notice(response.status, response.message)
        if (response.status == 'success') {
          // dimiss modal and body modal
          form.closest('.modal-update-post').modal('hide');
          update_post_real_time(form);
        } else {
          // show errors from response to input element
          var number_errors = 0;
          $.each(response.errors, function (key, values) {
            var input_attr_error = form.find("#post_" + key);
            $.each(values, function (index, value) {
              number_errors++;
              add_error_input(input_attr_error, key, value);
            });
          });
          add_total_error(form.find('.modal-header'), number_errors);
        }
      },
      error: function (xhr, ajaxOptions, thrownError) {
        console.log('error...', xhr);
      },
      complete: function () {
        modal_footer.html(old_html_modal_footer);
      }
    });
    return false;
  });

  $('body').on('click', '.cancel-button', function (event) {
    var form_element = $(this).closest('form');
    clear_form_error();
    reset_form(form_element, 'post', 'get', form_element.attr('action'));
  });

  $('body').on('submit', '.edit_post', function (event) {
    event.preventDefault();
    var form = $(this);
    var params = form.serialize();
    var method = method_form(form);
    var button = form.find('.load-more');
    var old_html_button = button.html();
    button_loading_style(button);
    $.ajax({
      type: method,
      url: form.attr('action'),
      data: params,
      dataType: 'json',
      success: function (response) {
        if (response.status == 'success') {
          form.find('#post_id_comment_continue').val(response.id_comment_continue);
          form.prev().before(response.html).hide();
          if (!response.continue_loading) {
            form.remove();
          }

        } else {
          console.log('sfdsf');
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
});

function show_error(messages) {
  $.each(messages, function (key, values) {
    $.each(values, function (index, value) {
      key = key.replace('_', ' ');
      $('.error-class').append('<div>' + key + ' ' + value + '<div>');
    });
  });
  $('#post_errors').addClass('in');

}

function clear_error() {
  $('.error-class').html('');
  $('#post_errors').removeClass('in');
}

function clear_input(form) {
  form.find('#post_context').val('');
  form.find('#post_title').val('');
}

function clear_form_error() {
  $('.errors-input').remove();
  $('.form-group').removeClass('has-error');
  $('.total-errors').remove();
}

function add_total_error(element, number_errors) {
  element.append('<div class="alert alert-danger total-errors">' + '<strong>'
    + 'You have ' + number_errors + ' Error!</strong></div>');
}

function add_error_input(input_attr_error, key, value) {
  input_attr_error.closest('.form-group').addClass('has-error');
  input_attr_error.after('<div class="help-block errors-input">'
    + key + ' ' + value + '</div>');
}

function update_post_real_time(form) {
  var post_title = form.find('#post_title').val();
  var post_context = form.find('#post_context').val();
  var post_area = form.closest('.modal-update-post').prev();
  post_area.find('.time-ago a').text('Updated less than a minute ago')
    .hide().fadeIn('slow');
  post_area.find('.post_title').text(post_title).hide().fadeIn('slow');
  post_area.find('.post_context').text(post_context).hide().fadeIn('slow');
}
