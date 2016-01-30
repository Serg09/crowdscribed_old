class InquiryMailer < ApplicationMailer
  default from: 'noreply@crowdscribed.com'

  def submission_notification(inquiry)
    inline_images
    @inquiry = inquiry
    mail to: 'info@crowdscribed.com', subject: "Crowdscribe inquiry #{('%06d' % inquiry.id)}"
  end
end