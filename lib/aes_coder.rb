require 'openssl'

# Advanced Encryption Standard symmetric algorithm with a key size of 256 bytes
# in chained block cipher mode, strengthened by a 16 byte initialization vector
class AESCoder
  KEY = File.read(File.join(Rails.root, "config", "aes.key"))

  def self.load(value)
    return unless value

    aes = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    aes.decrypt
    aes.key = KEY
    aes.iv = value.slice!(0, 16)
    decrypted = aes.update(value) + aes.final
  end

  def self.dump(value)
    return unless value

    aes = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    aes.encrypt
    aes.key = KEY
    iv = aes.random_iv
    encrypted = iv + aes.update(value) + aes.final
  end
end

AesCoder = AESCoder
