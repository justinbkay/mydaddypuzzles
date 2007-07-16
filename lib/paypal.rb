require 'net/http'
require 'uri'

    #1: Simple POST
    res = Net::HTTP.post_form(URI.parse('http://www.example.com/search.cgi'),
                              {'q'=>'ruby', 'max'=>'50'})