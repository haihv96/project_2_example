$(document).ready(function () {
  $('body').on('click', '.paginate_comment li', function (event) {
    event.preventDefault();
    var self = $(this).find('a');
    var body_element = self.closest('.panel-footer');
    var body_object = new AppElement(body_element);
    var li_object = new AppElement(self);
    li_object.only_icon_loading();
    body_object.loading_area();
    $.ajax({
      type: 'GET',
      url: get_url(self, body_element),
      dataType: 'json',
      success: function (response) {
        body_element.html(response.html).hide().fadeIn('normal');
      },
      complete: function () {
        body_object.remove_loading_area();
        li_object.reset();
        go_to_by_scroll(body_element);
      }
    });
  });
});

function get_url(self, body_element) {
  var base_url = '/posts/' +
    body_element.closest('.post-item').find('#post_id').val()
    + '/comments?page=';
  var str = self.attr('href');
  var index = str.indexOf('=');
  if (index == -1) {
    return base_url + '1';
  }
  return base_url + str.substr(index + 1);
}

function go_to_by_scroll(element) {
  $('html,body').animate({scrollTop: element.offset().top - 120}, 'slow');
}
