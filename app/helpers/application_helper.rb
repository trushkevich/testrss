module ApplicationHelper

  def format_date date
    date.strftime('%d.%m.%Y %H:%M')
  end

  def channel_name channel
    user_signed_in? ? channel.subscription_name(current_user) : channel.name
  end

end
