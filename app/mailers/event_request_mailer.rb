class EventRequestMailer < ActionMailer::Base

    def event_request(event, request_text)
      @request_text = request_text
      @event = event

      mail to: [event.contactemail, "abtech@andrew.cmu.edu"], from: "abtech@andrew.cmu.edu", subject: gen_subject(event)
    end

    def event_created(event, message_id)
      @event = event

      mail to: "abtech@andrew.cmu.edu", from: "abtech@andrew.cmu.edu", subject: gen_subject(event), references: "<#{message_id}>"
    end

    private
      def gen_subject(event)
        subject_date = event.eventdates[0].startdate.strftime("%m/%d/%Y")
        dev =
          if Rails.env.development?
            " DEVELOPMENT TEST"
          else
            ""
          end
        "[AB Tech#{dev}] Request | #{event.title} #{subject_date}"
      end
  end
