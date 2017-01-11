class NotebooksMailer < ActionMailer::Base
  include Resque::Mailer

  default from: 'Mod Notebooks <noreply@modnotebooks.com>'

  def notebook_submitted(notebook_id)
    @notebook = Notebook.find(notebook_id)
    subject = 'New notebook submitted for digitization'
    recipients = ['charles@modnotebooks.com', 'will.bowersox@gmail.com']

    mail(to: recipients , subject: subject)
  end

  def notebook_available(user_id, notebook_id)
    @user = User.find(user_id)
    @notebook = Notebook.find(notebook_id)
    subject = "Your notebook \"#{@notebook.name}\" has just been digitized!"

    mail(to: @user.email, subject: subject)
  end

  def notebook_returned(user_id, notebook_id)
    @user = User.find(user_id)
    @notebook = Notebook.find(notebook_id)
    subject = "Your notebook \"#{@notebook.name}\" is on its way back to you!"

    mail(to: @user.email, subject: subject)
  end
end
