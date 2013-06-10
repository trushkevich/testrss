class ChannelMailer < ActionMailer::Base
  default from: "noreply@testrss.loc"

  add_template_helper(ApplicationHelper)


  def recent_feeds_email
    @recent_feeds = Channel.order('updated_at DESC').limit(5)
    mail(:to => User.with_email.all.map(&:email),
         :subject => I18n.t('mailers.channel_mailer.recent_feeds_email.subject'))
  end

end
