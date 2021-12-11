require 'date'
require 'pstore'
require 'bundler'
Bundler.require
self.dbi

class BookInfo
  attr_accessor :title, :author, :page, :publish_date

  def initialize(title, author, page, publish_date)
    @title = title
    @author = author
    @page = page
    @publish_date = publish_date
  end

  def to_s
    "#{@title}, #{@author}, #{@page}, #{@publish_date}"
  end

  def to_formatted_string(sep = "\n")
    "書籍名: #{@title}#{sep}著者名: #{@author}#{sep}ページ数: #{@page}#{sep}出版日:#{@publish_date}#{sep}"
  end

  def to_csv(key)
    "#{key},#{@title},#{@author},#{@page},#{@publish_date}\n"
  end

  def ==(other)
    #インスタンス変数の一覧を配列として取得する
    instances = self.instance_variables
    skips = BookInfo.new("", "", 0, Date.new)
    instances.each do |instance|
      next if other.instance_variable_get(instance) == skips.instance_variable_get(instance)
      unless self.instance_variable_get(instance) == other.instance_variable_get(instance)
        return false
      end
    end
  end
end

class BookInfoManager
  def initialize(sqlite_name)
    @db_name = sqlite_name
    @dbh = DBI.connect("DBI:SQLite3:#{@db_name}")
    @book_infos = {}
    @matched_book_infos = {}
  end

def init_book_infos
  puts "\n0. 蔵書データベースの初期化"
  print "初期化しますか？（Y/yなら削除を実行します）"
  yesno = gets.chomp.upcase
  if /^y$/ =~ yesno
    @dbh.do("drop table if exists bookinfos")
    @dbh.do("create table bookinfos(
    id  varchar(50) not null,
    title varchar(100) not null,
    author varchar(100) not null,
    page int not null,
    publish_date datetime not null,
    primary key(id)
    );")
    puts "\nデータベースを初期化しました。"
  end
end

  def add_book_info
    #蔵書データ1件分のインスタンスを作成する
    book_info = BookInfo.new("", "", 0, Date.new)
    print "\n"
    print "キー:"
    key = gets.chomp
    print "書籍名:"
    book_info.title = gets.chomp
    print "著者名:"
    book_info.author = gets.chomp
    print "ページ数:"
    book_info.page = gets.chomp.to_i
    print "発刊年:"
    year = gets.chomp.to_i
    print "発刊月:"
    month = gets.chomp.to_i
    print "発刊日:"
    day = gets.chomp.to_i
    book_info.publish_date = Date.new(year, month, day)

    #作成した蔵書データの1件分をハッシュに登録する
    @dbh.do("insert into bookinfos values(
    ¥'#{key}'¥,
    ¥'#{book_info.title}¥',
    ¥'#{book_info.author}¥',
    ¥'#{book_info.page}¥',
    ¥'#{book_info.publish_date}¥''
    );")
    puts "\n登録しました。"
  end

  def list_all_books_infos(book_infos = @book_infos)
    item_name = {'id' => "キー", 'title' => "書籍名", 'author' => "著者名", 'page' => "ページ数", 'publish_date' => "発刊日"}
    puts "\n2. 蔵書データの表示"
    print "蔵書データを表示します"

    puts "\n----------"
    sth = @db.execute("select * from bookinfos")

    counts = 0
    sth.each do |row|
      row.each_with_name do |val, name|
        puts "#{item_name[name]}: #{val.to_s}"
      end
      puts "----------"
      counts += 1
    end

    sth.finish

    puts "\n#{counts}件表示しました。"
  end

  def search_book_info
    book_info = BookInfo.new("", "", 0, Date.new)
    print "\n"
    print "書籍名:"
    book_info.title = gets.chomp
    print "著者名:"
    book_info.author = gets.chomp
    print "ページ数:"
    book_info.page = gets.chomp.to_i
    print "発刊年:"
    year = gets.chomp.to_i
    print "発刊月:"
    month = gets.chomp.to_i
    print "発刊日:"
    day = gets.chomp.to_i

    begin
      book_info.publish_date = Date.new(year, month, day)
    rescue ArgumentError
      book_info.publish_date = Date.new
    end

    @book_infos.each do |key, value|
      if value == book_info
        @matched_book_infos[key] = value
      end
    end
    list_all_books_infos(@matched_book_infos)
  end

  def save_all_book_infos
    File.open(@csv_fname, "w:UTF-8") do |file|
      @book_infos.each do |key, info|
        file.print(info.to_csv(key))
      end
    end
  end

  def run
    while true
      print "
      1. 蔵書データの登録
      2. 蔵書データの表示
      3. 蔵書データの検索
      8. 蔵書データをファイルに書き込む
      9. 終了
      番号を選んでください{1, 2, 3, 8, 9}: "
      num = gets.chomp.to_i
      case num
      when 1
        add_book_info
      when 2
        list_all_books_infos
      when 3
        search_book_info
      when 8
        save_all_book_infos
      when 9
        break
      end
    end
  end
end

book_info_manager = BookInfoManager.new("book_info.csv")

book_info_manager.setup

book_info_manager.run
