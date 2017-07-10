$(document).ready(function () {
  $('body').on('keydown', '#search', function () {
    var self = $(this);
    var $form_object = new Form(self.closest('form'));
    var $button = new AppElement(self.closest('form').find('button'));

    var start = function () {
      $button.only_icon_loading();
      $form_object.clear_error();
    };
    var success = function (response) {
      $form_object.element.find('.search-result').html(response.html);
    };

    var complete = function () {
      $button.reset();
    };

    new AjaxFormRequest('json', $form_object)
      .request(start, success, null, null, complete, false);
  });
});
