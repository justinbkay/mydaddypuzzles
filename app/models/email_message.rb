class EmailMessage < ActiveRecord::Base
  validates_presence_of :message, :subject, :name
  validates_format_of :from_email,
                      :with => %r{^([ a-z0-9])+@([ a-z0-9_-])+(\.[a-zA-Z]+)$}i,
		      		        :message => "Doesn't look like a valid email address"
end
