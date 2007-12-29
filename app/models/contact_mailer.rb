class ContactMailer < ActionMailer::Base

  def contact_us(email)
    @subject    = email.subject
    @body       = {'e' => email}
    @recipients = 'PuzzleMaster <mydaddypuzzles@gmail.com>'
    @from       = "#{email.name} <#{email.from_email}>"
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def enter_drawing(entry)
    @subject    = "Drawing Entry for #{Date.today.strftime("%B")}"
    @body       = {'e' => entry}
    @recipients = 'PuzzleMaster <mydaddypuzzles@gmail.com>'
    @from       = "#{entry.name} <#{entry.email}>"
    @sent_on    = Time.now
    @headers    = {}
  end
end
