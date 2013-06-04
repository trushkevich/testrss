class UrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value !~ /^(?:(?:https?):\/\/)?(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z#{'00a1'.hex}-#{'ffff'.hex}0-9]+-?)*[a-z#{'00a1'.hex}-#{'ffff'.hex}0-9]+)(?:\.(?:[a-z#{'00a1'.hex}-#{'ffff'.hex}0-9]+-?)*[a-z#{'00a1'.hex}-#{'ffff'.hex}0-9]+)*(?:\.(?:[a-z#{'00a1'.hex}-#{'ffff'.hex}]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/iu
      record.errors.add attribute.to_s.gsub('_',' '), 'is not a valid URL'
    end
  end

end
