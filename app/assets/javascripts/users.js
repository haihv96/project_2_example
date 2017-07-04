$(document).ready(function () {
  $('#register_user').submit(function (event) {
    event.preventDefault();
    var self = $(this);
    var $form_object = new Form(self);
    var $button = new AppElement(self.find('#submit_new_user'));

    var start = function () {
      $button.default_loading();
      $form_object.clear_error();
    };
    var success = function (response) {
      $form_object.clear_input();
      $('#flash_message').html('<div class="alert alert-info">' +
        '<strong>' + response.flash + '</strong></div>');
    };
    var error = function (response) {
      $form_object.bootstrap_show_error('user', response.errors);
      $form_object.clear_password_field();
    };
    var complete = function () {
      $button.reset();
    };

    new AjaxFormRequest('json', $form_object)
      .request(start, success, null, error, complete, true);
  });

  $('body').on('submit', '#edit_profile_user', function (event) {
    event.preventDefault();
    var self = $(this);
    var $form_object = new Form(self);
    var $button = new AppElement(self.find('#button_edit_user'));

    var start = function () {
      $button.default_loading();
      $form_object.clear_error();
    };
    var error = function (response) {
      $form_object.bootstrap_show_error('user', response.errors);
    };
    var complete = function () {
      $button.reset();
    };

    new AjaxFormRequest('json', $form_object)
      .request(start, null, null, error, complete, true);
  });

  $('body').on('click', '#cancel_edit_user', function () {
    var form_object = new Form($(this).closest('form'));
    form_object.undo_input('user', 'get', 'users/' + $('#user_id').val());
  });

  $('#file_select').change(function () {
    var size_in_megabytes = this.files[0].size / 1024 / 1024;
    var ext = $(this).val().split('.').pop().toLowerCase();
    if ($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1) {
      alert(I18n.t('user.avatar.type_error'));
      return;
    }
    if (size_in_megabytes > 5) {
      alert(I18n.t('user.avatar.size_error'));
      return;
    }
    if ($(this).val() !== '') {
      var file = $('#file_select')[0].files[0];
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function (_file) {
        $('#current_avatar').hide();
        $('#jcrop_field').removeClass('hide').hide().fadeIn();
        html_import(_file);
        var checkExist = setInterval(function () {
          if ($('#user_avatar_cropbox').length) {
            new CarrierWaveCropper();
            clearInterval(checkExist);
          }
        }, 50);

      };
    }
  });
});

var CarrierWaveCropper,
  bind = function (fn, me) {
    return function () {
      return fn.apply(me, arguments);
    };
  };

CarrierWaveCropper = (function () {
  function CarrierWaveCropper() {
    this.updatePreview = bind(this.updatePreview, this);
    this.update = bind(this.update, this);
    this.jcrop_api = $.Jcrop('#user_avatar_cropbox', {
      aspectRatio: 1,
      setSelect: [0, 0, 200, 200],
      boxWidth: $('#crop_box').width(),
      onSelect: this.update,
      onChange: this.update
    });
  }

  CarrierWaveCropper.prototype.update = function (coords) {
    $('#user_avatar_crop_x').val(coords.x);
    $('#user_avatar_crop_y').val(coords.y);
    $('#user_avatar_crop_w').val(coords.w);
    $('#user_avatar_crop_h').val(coords.h);
    return this.updatePreview(coords);
  };

  CarrierWaveCropper.prototype.updatePreview = function (coords) {
    return $('#user_avatar_previewbox').css({
      width: Math.round(250 / coords.w * $('#user_avatar_cropbox').width()) + 'px',
      height: Math.round(250 / coords.h * $('#user_avatar_cropbox').height()) + 'px',
      marginLeft: '-' + Math.round(250 / coords.w * coords.x) + 'px',
      marginTop: '-' + Math.round(250 / coords.h * coords.y) + 'px'
    });
  };

  return CarrierWaveCropper;

})();

function avatar_cropbox(_file) {
  return '<div style="display:none">' +
    '<input id="user_avatar_crop_x" type="hidden" name="user[avatar_crop_x]">' +
    '<input id="user_avatar_crop_y" type="hidden" name="user[avatar_crop_y]">' +
    '<input id="user_avatar_crop_w" type="hidden" name="user[avatar_crop_w]">' +
    '<input id="user_avatar_crop_h" type="hidden" name="user[avatar_crop_h]">' +
    '</div><div id="user_avatar_cropbox_wrapper">' +
    '<img id="user_avatar_cropbox" src="' + _file.target.result + '">' +
    '</div>';
}

function avatar_previewbox(_file) {
  return '<div id="user_avatar_previewbox_wrapper" style="width:250px; height:250px; ' +
    'overflow:hidden">' +
    '<img id="user_avatar_previewbox" src="' + _file.target.result + '">' +
    '</div>' +
    '</div>';
}

function html_import(_file) {
  $('#crop_box').html(avatar_cropbox(_file));
  $('#preview_box').html(avatar_previewbox(_file));
}
