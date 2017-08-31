module Support
  module Helpers
    module Authentication
      def authenticate_user(email, password)
        post sessions_path, params: {
          email: email,
          password: password
        }

        auth_data = JSON.parse(response.body)

        yield auth_data['access_token']
      end

      def password_hash(password = SecureRandom.hex(10))
        BcryptAdapter.new.encode(password)
      end

      def with_auth_header(access_token, headers = {})
        headers.merge('Authorization' => "Bearer #{access_token}")
      end
    end
  end
end
