module Listeners
  module Helper
    def send_admin_message(subject, template, receiver_id)
      body = erb template
      admin_message subject, body, receiver_id
    end
    def link_to(name, path)
      helpers.link_to name, path
    end
    def number_to_currency(number)
      ActionController::Base.helpers.number_to_currency number
    end
    def helpers
      ActionController::Base.helpers
    end
    def url_helpers
      Rails.application.routes.url_helpers
    end
    def milestone_path(milestone)
      link_to "milestone #{milestone.id}",  "/milestones/#{milestone.id}"
    end
    
    private
    def admin_message(subject, body, receiver_id)
      message = Message.normal_message from:"System Admin", created_by:-1, subject: subject, body:body, to:receiver_id
      message.save!
    end
    def erb(template)
      ERB.new(template).result
    end
  end
end