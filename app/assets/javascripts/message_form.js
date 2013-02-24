var MessageForm = function MessageForm() {
};

// Instance methods
MessageForm.prototype = {

  initReadMessageForm: function initReadMessageForm() {

    $('#read-message').submit(function() {
      return false;
    });

    $("#read-message").validate({
      submitHandler: function() {
        var passphrase = $('#passphrase').val();
        var pbkdf_key = Gandhi.Crypto.generatePbkdfKeyFromPassphrase(passphrase);
        var data = {'encrypted_passphrase': pbkdf_key};
        $.ajax({
          type: "GET",
          url: '/api/view_message.json',
          data: data,
          success: Gandhi.MessageForm.onReadSuccess,
          statusCode: {
            422: Gandhi.MessageForm.onReadError
          },
          dataType: 'json'
        });
        return false;
      },
      rules: {
        'passphrase': {
          required: true,
          minlength: 8
        }
      },
      messages: {
        'passphrase': "This is a required field (min. 8 characters)."
      }
    });

  },

  initCreateMessageForm: function initCreateMessageForm() {
    $('#new-message').submit(function() {
      return false;
    });
    $("#new-message").validate({

      submitHandler: function() {
        // $('#pleaseWaitModal').modal();
        var expires_at = $('input[name="message[expires_at]"]:checked', '#new-message').val();
        var destroy_after = $('input[name="message[destroy_after]"]:checked', '#new-message').val();
        var passphrase = $('#passphrase').val();
        var pbkdf_key = Gandhi.Crypto.generatePbkdfKeyFromPassphrase(passphrase);
        var message_body = $('#message-body').val();
        var encrypted = Gandhi.Crypto.encryptMessage(message_body, pbkdf_key);
        var message_data = {'message[body]': encrypted,
                            'message[encrypted_passphrase]': pbkdf_key,
                            'message[expires_at]': expires_at,
                            'message[destroy_after]': destroy_after
                           };
        $.ajax({
          type: "POST",
          url: '/api/create_message.json',
          data: message_data,
          success: Gandhi.MessageForm.onCreateSuccess,
          statusCode: {
            422: Gandhi.MessageForm.onCreateError
          },
          dataType: 'json'
        });
        return false;
      },
      rules: {
        'body': "required",
        'passphrase': {
          required: true,
          minlength: 8
        }
      },
      messages: {
        'body': "Please enter a message",
        'passphrase': "Please enter a passphrase (minimum of 8 characters). Passphrases are cAsE sEnSitIvE, may include spaces, letters, numbers and other special characters."
      }
    });
  },

  onCreateSuccess: function onCreateSuccess(data, textStatus, jq_xhr) {
    // $('#pleaseWaitModal').modal('hide');
    $('#messageCreatedModal').modal();
    $('#messageCreatedModal').append('<div id="message-created" style="display: none;">true</div>');
    // Reset the form
    document.getElementById("new-message").reset();
  },

  onCreateError: function onCreateError(jq_xhr, textStatus, errorThrown) {
    alert("There was a problem creating your message. Please try again later.");
  },

  onReadSuccess: function onReadSuccess(data, textStatus, jq_xhr) {
    var encrypted_message = data.message;
    var pbkdf_key = data.encrypted_passphrase;
    var decrypted = Gandhi.Crypto.decryptMessage(encrypted_message, pbkdf_key);
    var message_text_utf8 = CryptoJS.enc.Utf8.stringify(decrypted);
    var message_html = "<pre>" + message_text_utf8 + "</pre>";
    $('#show-message-body').html(message_html);
    $('#showMessageModal').modal();
  },

  onReadError: function onReadError(jq_xhr, textStatus, errorThrown) {
    alert("Message not found.");
  }

};