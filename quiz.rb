require 'mechanize'
require 'nokogiri'

class Quiz

  EMAIL = 'test@example.com'.freeze
  PASS  = 'secret'.freeze

  def run
    hash = {}
    Mechanize.new.get('https://staqresults.herokuapp.com') do |home_page|
      reports = home_page.form_with(id: 'form-signin') do |form|
        form.email    = EMAIL
        form.password = PASS
      end.submit

      reports.search('tbody > tr').each do |row|
        coloumns = row.search('td')
          hash[coloumns[0].text] = {
            tests: coloumns[1].text,
            passes: coloumns[2].text,
            failures: coloumns[3].text,
            pending: coloumns[4].text,
            coverage: coloumns[5].text
          }
      end
    end
    hash
  end
end
