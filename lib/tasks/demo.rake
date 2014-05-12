# http://itshouldbeuseful.wordpress.com/2011/11/07/passing-parameters-to-a-rake-task/

namespace :demo do

  desc "Generate user/notebooks for demo account"
  task bootstrap: [:environment] do
    user = User.create_with(
      password: 'password',
      password_confirmation: 'password'
    ).find_or_create_by(email: 'demo@modnotebooks.com')
    user.confirm!

    notebook = Notebook.find_or_create_by(notebook_identifier: '01-01-demo01')

    unless notebook.submitted_on.present?
      notebook.submit!(user, { name: 'Video Sketches', handle_method: 'return' })
    end

    unless notebook.received_on.present?
      notebook.receive!
    end

    notebook.upload!(File.open("#{Rails.root}/spec/demo_scan.pdf"))
    notebook.process!
  end

end
