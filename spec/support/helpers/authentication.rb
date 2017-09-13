module Support
  module Helpers
    module Authentication
      def authenticate_user(email, password)
        post sessions_path, params: {
          email: email,
          password: password
        }

        auth_result = JSON.parse(response.body)

        yield auth_result['data']['access_token'] if block_given?
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
