namespace :notebook_settings do

  desc "Bootstrap Notebook settings with the default notebook colors"
  task bootstrap: :environment do |t|

    # Mod Grey
    NotebookSetting
      .create_with(name: 'Mod Grey', color: '#a2a2a2')
      .find_or_create_by!(color_code: '01')

    # Mod Red
    NotebookSetting
      .create_with(name: 'Mod Red', color: '#ca3b3e')
      .find_or_create_by!(color_code: '02')

    # Mod Black
    NotebookSetting
      .create_with(name: 'Mod Black', color: '#212222')
      .find_or_create_by!(color_code: '03')

  end
end
