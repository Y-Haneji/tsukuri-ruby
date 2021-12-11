require 'date'
require 'pstore'

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
    "書籍名: #{@title}#{sep}著者名: #{@author}#{sep}ページ数: #{@page}ページ#{sep}出版日:#{@publish_date}#{sep}"
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
  def initialize(pstore_name)
    @db = PStore.new(pstore_name)
    @book_infos = {}
    @matched_book_infos = {}
  end

  # def setup
  #   File.open(@csv_fname, "r:UTF-8") do |file|
  #     file.each do |line|
  #       key, title, author, page, date = line.chomp.split(",")
  #       @book_infos[key] = BookInfo.new(title, author, page.to_i, Date.strptime(date))
  #     end
  #   end
  #   # @book_infos["Yamada2005"] = BookInfo.new(
  #   # "実践アジャイル ソフトウェア開発方とプロジェクト管理",
  #   # "山田 正紀",
  #   # 248,
  #   # Date.new(2005, 1, 25)
  #   # )
  #   # @book_infos["Ooba2006"] = BookInfo.new(
  #   # "入門LEGO MiNDSTORMS NXT レゴブロックで作る動くロボット",
  #   # "大庭 慎一郎",
  #   # 164,
  #   # Date.new(2006, 12, 23)
  #   # )
  # end

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

    #作成した蔵書データの1件分をデータベースに登録する
    @db.transaction do
      @db[key] = book_info
    end
  end

  def list_all_books_infos(book_infos = @book_infos)
    puts "\n----------"
    @db.transaction(true) do
      @db.roots.each do |key|
        puts "キー: #{key}"
        print @db[key].to_formatted_string
        puts "\n----------"
      end
    end
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

    @db.transaction do
      @db.roots.each do |key|
        if @db[key] == book_info
          @matched_book_infos[key] = @db[key]
        end
      end
    end
    list_all_books_infos(@matched_book_infos)
  end

  # def save_all_book_infos
  #   File.open(@csv_fname, "w:UTF-8") do |file|
  #     @book_infos.each do |key, info|
  #       file.print(info.to_csv(key))
  #     end
  #   end
  # end

  def del_book_info
    print "\n"
    print "キーを指定してください:"
    key = gets.chomp

    @db.transaction do
      if @db.root?(key)
        print @db[key].to_formatted_string
        print "\n削除しますか？(Y/yなら削除を実行します):"
        yesno = gets.chomp.upcase
        if /^Y$/ =~ yesno
          @db.delete(key)
          puts "\nデータベースから削除しました"
        end
      end
    end
  end

  def run
    while true
      print "
      1. 蔵書データの登録
      2. 蔵書データの表示
      3. 蔵書データの検索
      4. 蔵書データの削除
      9. 終了
      番号を選んでください{1, 2, 3, 4, 9}: "
      num = gets.chomp.to_i
      case num
      when 1
        add_book_info
      when 2
        list_all_books_infos
      when 3
        search_book_info
      when 4
        del_book_info
      # when 8
      #   save_all_book_infos
      when 9
        break
      end
    end
  end
end

book_info_manager = BookInfoManager.new("book_info.db")

book_info_manager.run
