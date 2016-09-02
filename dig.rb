require 'rubygems'
require 'net/dns'
require 'csv'

def load_csv
  CSV.read("us_hostheaders.csv", {:col_sep => ';'})
end

def process_csv(hostheader)
  CSV.open("t2_arecords_export.csv","wb")
    hostheader.each do |url|
      # get the answer from dig and check for bad URL's
      if /\s/.match(url.first)
        puts "Invalid URL (whitespace found)"
        CSV.open("t2_arecords_export.csv", "ab") do |csv|
          csv << ["Invalid URL (whitespace found)"]
        end
      else
        begin
          tries ||= 3
          url = Resolver(url.first)
        rescue Exception => e
            retry unless (tries -= 1).zero?
        else
          CSV.open("t2_arecords_export.csv", "ab") do |csv|
            csv << ["#{url.answer.first}"]
          end
        end
        print "#{url.answer.first}\n"
        # write the answer to arecords csv
      #  CSV.open("t2_arecords_export.csv", "ab") do |csv|
      #    csv << ["#{url.answer.first}"]
      #  end
      end
    end
end


us_sites = load_csv()

process_csv(us_sites)
