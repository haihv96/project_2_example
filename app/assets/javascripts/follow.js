$(document).ready(function () {
  $('body').on('submit', '.new_relationship', function (event) {
    event.preventDefault();
    var $self = $(this);
    var $form_object = new Form($self);
    var $button = new AppElement($self.find('.button-follow'));

    var start = function () {
      $button.default_loading();
      $form_object.clear_error();
    };
    var success = function (response) {
      $self.closest('.follow-field').html(response.html).hide().fadeIn('normal');
    };
    var complete = function () {
      $button.reset();
    };

    new AjaxFormRequest('json', $form_object)
      .request(start, success, null, null, complete, true);
  });

  $('body').on('submit', '.edit_relationship', function (event) {
    event.preventDefault();
    var $self = $(this);
    var $form_object = new Form($self);
    var $button = new AppElement($self.find('.button-unfollow'));

    var start = function () {
      $button.default_loading();
      $form_object.clear_error();
    };
    var success = function (response) {
      $self.closest('.follow-field').html(response.html).hide().fadeIn('normal');
    };
    var complete = function () {
      $button.reset();
    };

    new AjaxFormRequest('json', $form_object)
      .request(start, success, null, null, complete, true);
  });
});
