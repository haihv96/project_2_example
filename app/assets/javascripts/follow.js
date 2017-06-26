$(document).ready(function () {
  $('body').on('submit', '.new_relationship', function (event) {
    event.preventDefault();
    var form = $(this);
    var params = form.serialize();
    var method = method_form(form);
    var button = form.find('.button-follow');
    var old_html_button = button.html();
    button_loading_style(button);
    $.ajax({
      type: method,
      url: form.attr('action'),
      data: params,
      dataType: 'json',
      success: function (response) {
        page_notice(response.status, response.message)
        if (response.status == 'success') {
          form.closest('.follow').html(response.html).hide().fadeIn('normal');
          if ($('#profile-page').length) {
            increase_follow($('#count_followers'));
          } else {
            increase_follow($('#count_following'));
          }
        }
        else {
          reset_button(button, old_html_button);
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

  $('body').on('submit', '.edit_relationship', function (event) {
    event.preventDefault();
    var form = $(this);
    var params = form.serialize();
    var method = method_form(form);
    var button = form.find('.button-unfollow');
    var old_html_button = button.html();
    button_loading_style(button);
    $.ajax({
      type: method,
      url: form.attr('action'),
      data: params,
      dataType: 'json',
      success: function (response) {
        page_notice(response.status, response.message)
        if (response.status == 'success') {
          form.closest('.follow').html(response.html).hide().fadeIn('normal');
          if ($('#profile-page').length) {
            decrease_follow($('#count_followers'));
          } else {
            decrease_follow($('#count_following'));
          }
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

function increase_follow(element) {
  element.text(parseInt(element.text()) + 1);
}
function decrease_follow(element) {
  element.text(parseInt(element.text()) - 1);
}
