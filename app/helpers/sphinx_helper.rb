module SphinxHelper
  SYMBOLS_MAP = { 
                  "а"=>"f", "б"=>",", "в"=>"d", "г"=>"u", "д"=>"l", "е"=>"t",
                  "ё"=>"`", "ж"=>";", "з"=>"p", "и"=>"b", "й"=>"q", "к"=>"r",
                  "л"=>"k", "м"=>"v", "н"=>"y", "о"=>"j", "п"=>"g", "р"=>"h",
                  "с"=>"c", "т"=>"n", "у"=>"e", "ф"=>"a", "х"=>"[", "ц"=>"w",
                  "ч"=>"x", "ш"=>"i", "щ"=>"o", "ъ"=>"]", "ы"=>"s", "ь"=>"m",
                  "э"=>"'", "ю"=>".", "я"=>"z"
                }

  def self.misprints_to_word(str)
    arr = str.split("")
    new_str = arr.map {|c| SYMBOLS_MAP.select { |k, _| c == k }.values}
                 .flatten
                 .join
  end

  def misprints_to_word(str)
    SphinxHelper.misprints_to_word(str)
  end
end