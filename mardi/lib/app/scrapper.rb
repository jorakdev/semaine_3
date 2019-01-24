require 'pry'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'google_drive'
require 'csv'

class Scrapper
  page = Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html'))
  commune_val = page.xpath('//*[@class="lientxt"]')

  tab_link = []
  commune_val.each do |link|
    _tab = link.text # ou n'importe quelle autre opération de ton choix ;)
    tab_link << _tab
  end

  new = []
  tab_link.each do |elm_tab|
    _new = elm_tab.tr(' ', '-')
    new << _new
  end

  town = []
  new.each do |down|
    _town = down.downcase
    town << _town
  end

  mail_commune_val = []
  town.each do |nom_ville|
    page_95 = Nokogiri::HTML(open("http://annuaire-des-mairies.com/95/#{nom_ville}.html"))
    _mail_commune_val = page_95.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]')
    mail_commune_val << _mail_commune_val
  end

  tab = []
  mail_commune_val.each do |email_link|
    _tab = email_link.text # ou n'importe quelle autre opération de ton choix ;)
    tab << _tab
  end

  # town.each do |n|
  # puts ("http://annuaire-des-mairies.com/95/#{n}.html")
  # end
  $a = Hash[tab_link.zip(tab)]

  def save_as_JSON
    File.open('/home/jo/Bureau/semaine_3/mardi/db/emails.json', 'w') do |f|
      f.write($a.to_json)
    end
  end

    def save_as_csv
      CSV.open('/home/jo/Bureau/semaine_3/mardi/db/emails.csv', 'wb') do |csv|
        $a.to_a.each do |elm|
          csv << elm
        end
      end
    end

    def gsheet
      session = GoogleDrive::Session.from_config("config.json")
      ws = session.spreadsheet_by_key("11bbHCNMymfqpSO5Utg_UAHoEQnUpNbXDk0by3o5D7NY").worksheets[0]

        i = 1
        $a.each do |key, value|
            ws[i, 1] = key
            ws[i, 2] = value
            ws.save
            ws.reload
            i +=1
            if i == 10
              break
            end
        end
    end
end

#binding.pry
