require 'openssl'
require 'base64'

module SecupayRuby
  module ApiKey
    class SubKey
      attr_reader :ciphertext, :iv, :project_name, :mac
      attr_accessor :contract_id, :payin_account

      # Changing "iv", "mac" or "project_name" will cause a bad decrypt when getting key!
      def initialize(ciphertext:, iv:, mac:, project_name:, contract_id: , payin_account: {})
        @ciphertext = ciphertext
        @iv = iv
        @project_name = project_name
        @mac = mac
        self.contract_id = contract_id
        self.payin_account = payin_account
      end

      def key
        decrypt
      end

      private

      def decrypt
        d = self.class.cipher
        d.decrypt
        d.key = self.class.generate_secure_key
        d.iv = Base64.decode64(iv)
        d.auth_tag = Base64.decode64(mac)
        d.auth_data = project_name

        d.update(Base64.decode64(ciphertext)) + d.final
      end

      class << self
        def request_api_key(project_name:, user:, payout_account:)
          response = make_api_call(project_name, user, payout_account)

          new_api_key = response.data["apikey"]
          contract_id = response.data["contract_id"]
          payin_account = response.data["payin_account"]

          encryption = encrypt(new_api_key, project_name)

          self.new(
            ciphertext: encryption[:ciphertext],
            iv: encryption[:iv],
            project_name: project_name,
            mac: encryption[:mac],
            contract_id: contract_id,
            payin_account: payin_account
          )
        end

        def generate_secure_key
          @secure_key ||= begin
            pass = SecupayRuby.config.api_key
            salt = "dflkhjfdgljhndgjlbnskjdbkh"
            iter = 20000
            key_len = 16
            OpenSSL::PKCS5.pbkdf2_hmac_sha1(pass, salt, iter, key_len)
          end
        end

        def cipher
          OpenSSL::Cipher.new("aes-128-gcm")
        end

        private

        def make_api_call(project_name, user, payout_account)
          body = {
            project: { name: project_name },
            user: user.to_api_fields,
            payout_account: payout_account.to_api_fields
          }
          response = SecupayRuby::Requests::RequestApiKey.post(api_key: SecupayRuby::ApiKey::MasterKey.new,
                                                               body: body)
        end

        def encrypt(plaintext, auth_data)
          e = self.cipher
          e.encrypt
          e.key = self.generate_secure_key
          iv = e.random_iv
          e.auth_data = auth_data
          ciphertext = e.update(plaintext) + e.final

          {
            iv: Base64.encode64(iv),
            ciphertext: Base64.encode64(ciphertext),
            mac: Base64.encode64(e.auth_tag)
          }
        end
      end
    end
  end
end