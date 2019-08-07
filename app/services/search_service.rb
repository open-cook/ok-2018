# frozen_string_literal: true

module SearchService
  PUBLICATION_TYPES = [
    Recipe, Post, Blog, Page, Interview
  ].freeze

  LOWERCASE_DICTIONARY = {
    'q' => 'й', 'w' => 'ц', 'e' => 'у', 'r' => 'к',
    't' => 'е', 'y' => 'н', 'u' => 'г', 'i' => 'ш',
    'o' => 'щ', 'p' => 'з', 'a' => 'ф', 's' => 'ы',
    'd' => 'в', 'f' => 'а', 'g' => 'п', 'h' => 'р',
    'j' => 'о', 'k' => 'л', 'l' => 'д', ';' => 'ж',
    "'" => 'э', 'z' => 'я', 'x' => 'ч', 'c' => 'с',
    'v' => 'м', 'b' => 'и', 'n' => 'т', 'm' => 'ь',
    ',' => 'б', '.' => 'ю'
  }.freeze

  UPPERCASE_DICTIONARY = {
    'Q' => 'Й', 'W' => 'Ц', 'E' => 'У', 'R' => 'К',
    'T' => 'Е', 'Y' => 'Н', 'U' => 'Г', 'I' => 'Ш',
    'O' => 'Щ', 'P' => 'З', 'A' => 'Ф', 'S' => 'Ы',
    'D' => 'В', 'F' => 'А', 'G' => 'П', 'H' => 'Р',
    'J' => 'О', 'K' => 'Л', 'L' => 'Д', ':' => 'Ж',
    '"' => 'Э', 'Z' => 'Я', 'X' => 'Ч', 'С' => 'С',
    'V' => 'М', 'B' => 'И', 'N' => 'Т', 'M' => 'Ь',
    '<' => 'Б', '>' => 'Ю'
  }.freeze

  def call(query, hub_ids, params)
    query = query.to_s.strip
    riddle_query = Riddle::Query.escape(query)

    search_result = if hub_ids.blank?
                      ThinkingSphinx.search(riddle_query, star: true, classes: PUBLICATION_TYPES, sql: { include: :hub }).pagination(params)
                    else
                      ThinkingSphinx.search(riddle_query, star: true, classes: PUBLICATION_TYPES, sql: { include: :hub }, with: { hub_id: hub_ids }).pagination(params)
    end

    if search_result.blank?
      OpenStruct.new(search_result: search_by_multiple_keyboard_layouts(query, params), multiple_keyboard_layouts: true)
    else
      OpenStruct.new(search_result: search_result, multiple_keyboard_layouts: false)
    end
  end

  module_function :call

  def convert_to_another_keyboard_layout(query)
    search_query = []

    query.each_char do |char|
      search_query.push(dictionary[char])
    end

    search_query.join
  end

  module_function :convert_to_another_keyboard_layout

  private

  def search_by_multiple_keyboard_layouts(query, params)
    ThinkingSphinx.search(Riddle::Query.escape(convert_to_another_keyboard_layout(query)), star: true, classes: PUBLICATION_TYPES, sql: { include: :hub }).pagination(params)
  end

  module_function :search_by_multiple_keyboard_layouts

  def dictionary
    LOWERCASE_DICTIONARY.merge(UPPERCASE_DICTIONARY)
  end

  module_function :dictionary
end
