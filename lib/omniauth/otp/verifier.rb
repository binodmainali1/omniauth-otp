module OmniAuth
  module Otp
    class Verifier

      attr_reader :otp

      def initialize otp
        @otp = otp
      end

      def verify(otp)
        response = get_response(otp)
        Result.new(otp, response)
      end

      def verify!(otp)
        result = verify(otp)
        raise OtpError, "Received error: #{result.status}" unless result.valid?
        result
      end

      private

      def get_response(otp)
        uri = URI.parse(api_url) + "verify"
        uri.query = "id=#{api_id}&otp=#{otp}"

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)

        response = http.request(request).body

        response
      end

    end
  end
end