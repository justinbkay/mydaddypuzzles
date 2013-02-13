class ContactMailer < ActionMailer::Base

  def contact_us(email)
    @e = email
    mail(:to => 'PuzzleMater <mydaddypuzzles@gmail.com>',
         :from => "#{email.name} <#{email.from_email}>",
         :subject => email.subject)
  end

  def enter_drawing(entry)
    @e = entry
    mail(:to => 'PuzzleMaster <mydaddypuzzles@gmail.com>',
         :from => "#{entry.name} <#{entry.email}>",
         :subject => "Drawing Entry for #{Date.today.strftime("%B")}")
  end

  def order_to_fill(order)
    @order = order
    mail(:to => 'PuzzleMaster <mydaddypuzzles@gmail.com>',
         :from => 'mydaddypuzzles@gmail.com',
         :bcc => 'justinbkay@gmail.com',
         :subject => 'Order to fill')
  end

end
