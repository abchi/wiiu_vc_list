require "csv"
require "sqlite3"
require "time"

db = SQLite3::Database.new "/Users/abchi/box/Ruby/wiiu_vc_list/db/development.sqlite3"
sql = "INSERT INTO games(id, name, hardware, genre, relese_date, price, maker, soft_type, title_url, image_url, created_at, updated_at) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

csv_data = CSV.read("./wiiu_vc_add_info.csv")
csv_data.each do |data|
    time = Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")
    db.execute(sql, data[0], data[1], data[2], data[3], Date.parse(data[4]).strftime("%Y-%m-%d"), data[5].delete("^0-9"), data[6], data[7], data[8], data[9], time, time)
end
