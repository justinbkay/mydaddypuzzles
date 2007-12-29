class Entry < ActiveRecord::Base
  validates_presence_of :name, :address, :city, :state, :zip
  validates_format_of :email,
                      :with => %r{^([ a-z0-9])+@([ a-z0-9_-])+(\.[a-zA-Z]+)$}i,
		      		        :message => "Doesn't look like a valid email address"
	validates_format_of :phone,
	                    :with => /\(*([0-9]){3}\)*[\s-]*([0-9]){3}[\s-]*([0-9]){4}/,
	                    :message => "Invalid phone number use (NNN) NNN-NNNN format"
	                    
end
