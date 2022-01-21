class JoinRequestMailer < ActionMailer::Base

    def join_request(andrew_id, preferred_name, last_name)
      @preferred_name = preferred_name
      @last_name = last_name

      mail to: ["#{andrew_id}@andrew.cmu.edu", "abtech+join@andrew.cmu.edu"], from: "abtech+join@andrew.cmu.edu", subject: gen_subject(preferred_name)
    end


    private
      def gen_subject(preferred_name)
        dev =
          if Rails.env.development?
            " DEVELOPMENT TEST"
          elsif Rails.env.staging?
            " STAGING TEST"
          else
            ""
          end
        "[AB Tech#{dev}] Greetings #{preferred_name}"
      end
  end
