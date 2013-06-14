ActiveAdmin.register Channel do
  menu :priority => 3

  index do |channel|
    column :id
    column :url
    column :name

    default_actions
  end  

  show do |ad|
    attributes_table do
      row :id
      row :url
      row :name
    end
    active_admin_comments
  end

  form do |f|
    f.inputs I18n.t('general.details') do
      f.input :url
      f.input :name
    end
    f.actions
  end

end
