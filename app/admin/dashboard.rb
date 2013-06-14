ActiveAdmin.register_page I18n.t("general.dashboard") do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel I18n.t("general.users") do
          span class: 'bold' do
            I18n.t("general.total_users")
          end
          span User.count
        end
      end

      column do
        panel I18n.t("general.channels") do
          span class: 'bold' do
            I18n.t("general.total_channels")
          end
          span Channel.count
        end
      end

      column do
        panel I18n.t("general.articles") do
          span class: 'bold' do
            I18n.t("general.total_articles")
          end
          span Article.count
        end
      end
    end

  end # content
end