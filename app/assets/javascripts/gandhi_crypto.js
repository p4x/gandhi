var GandhiCrypto = function GandhiCrypto() {
};

// Instance methods
GandhiCrypto.prototype = {

  // Given a passphrase, generate a PBKDF2 key of 256 bits and return a Bas64 representation of it.
  // Usage:
  //   var gc = new GandhiCrypto();
  //   var pbkdf_key = gc.generatePbkdfKeyFromPassphrase('sunshine puppy dogs 27');
  generatePbkdfKeyFromPassphrase: function generatePbkdfKeyFromPassphrase(passphrase) {
    // keySize is 256/32 or 8
    var key = CryptoJS.PBKDF2(passphrase, Gandhi.ClientSaltWords, { keySize: 8, iterations: Gandhi.Iterations });
    var key_base64 = CryptoJS.enc.Base64.stringify(key);
    return key_base64;
  },

  // Returns an OpenSSL compatible string representation of the cipher
  encryptMessage: function encryptMessage(message, key) {
    // Parse message as UTF8 into word array
    var message_words = CryptoJS.enc.Utf8.parse(message);
    // Parse message back into UTF8
    var message_utf8 = CryptoJS.enc.Utf8.stringify(message_words);
    // Encrypt the message
    var encrypted = CryptoJS.AES.encrypt(message_utf8, key);
    // Save the cipher and related information as an OpenSSL-compatible string
    var encrypted_tostring = encrypted.toString();
    return encrypted_tostring;
  },

  decryptMessage: function decryptMessage(encrypted_message, key) {
    var decrypted = CryptoJS.AES.decrypt(encrypted_message, key);
    return decrypted;
  }

};
