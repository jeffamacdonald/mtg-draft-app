# frozen_string_literal: true

require "strscan"

module Cubes
  # Applies a Cube Cobra / Scryfall style search string (e.g. `t:creature (c:r or c:g) mv<=3 -o:flying`)
  # to a CubeCard scope that already joins `cards` (see CubeCard.sorted).
  #
  # Only fields backed by data we store are supported. Anything else is skipped and reported
  # through #ignored so the UI can say so, as Cube Cobra does.
  class FilterQuery
    Term = Struct.new(:negated, :key, :op, :value, :raw)

    COMPARISON_OPS = { ":" => "=", "=" => "=", "!=" => "<>", "<>" => "<>", "<" => "<", ">" => ">", "<=" => "<=", ">=" => ">=" }.freeze
    VALUE = %r{"[^"]*"|'[^']*'|/(?:\\.|[^/\\])*/|[^\s()]+}
    KEYED_TERM = /(?<key>[a-z]+)(?<op>!=|<>|<=|>=|:|=|<|>)(?<value>#{VALUE})/i
    BARE_TERM = /!?(?:"[^"]*"|[^\s()]+)/

    COLOR = "array_remove(array_remove(cube_cards.custom_color_identity, 'C'), 'L')"
    MV = "cube_cards.custom_cmc"
    STATS = {
      "pow" => "cards.power", "power" => "cards.power",
      "tou" => "cards.toughness", "toughness" => "cards.toughness",
      "pt" => "(cards.power + cards.toughness)", "powtou" => "(cards.power + cards.toughness)",
      "mv" => MV, "cmc" => MV, "manavalue" => MV
    }.freeze
    NAME = "REPLACE(REPLACE(cards.name, '''', ''), '’', '')"
    ORACLE_WITHOUT_REMINDER = "regexp_replace(cards.card_text, '\\([^)]*\\)', '', 'g')"
    MAX_QUERY_LENGTH = 300
    MAX_REGEXES = 5
    MAX_REGEX_LENGTH = 200

    COLOR_NAMES = {
      "white" => "w", "blue" => "u", "black" => "b", "red" => "r", "green" => "g", "colorless" => "c",
      "azorius" => "wu", "dimir" => "ub", "rakdos" => "br", "gruul" => "rg", "selesnya" => "gw",
      "orzhov" => "wb", "izzet" => "ur", "golgari" => "bg", "boros" => "rw", "simic" => "gu",
      "bant" => "gwu", "esper" => "wub", "grixis" => "ubr", "jund" => "brg", "naya" => "rgw",
      "abzan" => "wbg", "jeskai" => "urw", "sultai" => "bgu", "mardu" => "rwb", "temur" => "gur",
      "silverquill" => "wb", "prismari" => "ur", "witherbloom" => "bg", "lorehold" => "rw", "quandrix" => "gu",
      "chaos" => "bgru", "aggression" => "bgrw", "altruism" => "rguw", "growth" => "bguw", "artifice" => "buwr"
    }.freeze

    # is:/has: keywords that map straight to a SQL condition
    IS_CONDITIONS = {
      "gold" => "cardinality(#{COLOR}) >= 2",
      "multicolor" => "cardinality(#{COLOR}) >= 2",
      "hybrid" => "cards.cost ~ '\\{[^}]*/[^}]*\\}'",
      "phyrexian" => "(cards.cost ~ '/P\\}' OR cards.card_text ~ '/P\\}')",
      "twobrid" => "cards.cost ~ '\\{2/'",
      "permanent" => "cards.type_line !~* '(instant|sorcery)'",
      "spell" => "cards.type_line !~* 'land'",
      "dfc" => "cards.layout IN ('transform', 'modal_dfc', 'double_faced_token', 'reversible_card', 'art_series')",
      "mdfc" => "cards.layout = 'modal_dfc'",
      "tdfc" => "cards.layout = 'transform'"
    }.freeze
    IS_LAYOUTS = %w[transform split flip adventure meld leveler saga].freeze

    attr_reader :ignored

    def initialize(text)
      @text = text.to_s.first(MAX_QUERY_LENGTH)
      @ignored = []
      @regex_count = 0
    end

    def apply(scope)
      sql = to_sql
      sql ? scope.where(sql) : scope
    end

    def to_sql
      @tokens = tokenize
      parts = []
      until @tokens.empty?
        parts << parse_or
        @tokens.shift if @tokens.first == :rparen # stray ")"
      end
      combine(parts, "AND")
    end

    private

    # ---- tokenizing and parsing ----

    def tokenize
      scanner = StringScanner.new(@text)
      tokens = []
      until scanner.eos?
        next if scanner.skip(/\s+/)
        if scanner.scan(/-\(/) then tokens << :neg_lparen
        elsif scanner.scan(/\(/) then tokens << :lparen
        elsif scanner.scan(/\)/) then tokens << :rparen
        elsif scanner.scan(/or(?=[\s()]|\z)/i) then tokens << :or
        elsif scanner.scan(/and(?=[\s()]|\z)/i) then next
        else
          negated = !scanner.scan(/-/).nil?
          if scanner.scan(KEYED_TERM)
            tokens << Term.new(negated, scanner[:key].downcase, scanner[:op], unquote(scanner[:value]), scanner.matched.delete_prefix("-"))
          elsif scanner.scan(BARE_TERM)
            tokens << Term.new(negated, "name", ":", unquote(scanner.matched.delete_prefix("!")), scanner.matched).tap { |t| t.op = "=" if scanner.matched.start_with?("!") }
          else
            scanner.getch
          end
        end
      end
      tokens
    end

    def unquote(value)
      value.match?(/\A(["']).*\1\z/) ? value[1..-2] : value
    end

    def parse_or
      groups = [ parse_and ]
      groups << parse_and while @tokens.first == :or && @tokens.shift
      combine(groups, "OR")
    end

    def parse_and
      parts = []
      parts << parse_unit while @tokens.any? && ![ :or, :rparen ].include?(@tokens.first)
      combine(parts, "AND")
    end

    def parse_unit
      token = @tokens.shift
      case token
      when :lparen, :neg_lparen
        sql = parse_or
        @tokens.shift if @tokens.first == :rparen
        token == :neg_lparen ? negate(sql) : sql
      when Term
        sql = compile(token)
        @ignored << token.raw if sql.nil?
        token.negated ? negate(sql) : sql
      end
    end

    def combine(parts, joiner)
      parts = parts.compact
      return nil if parts.empty?
      parts.one? ? parts.first : "(#{parts.join(" #{joiner} ")})"
    end

    def negate(sql)
      sql && "NOT COALESCE(#{sql}, FALSE)"
    end

    # ---- compiling terms to SQL ----

    def compile(term)
      case term.key
      when "name", "n" then text_match("cards.name", term, name: true)
      when "o", "oracle" then text_match(ORACLE_WITHOUT_REMINDER, term)
      when "fo", "fulloracle" then text_match("cards.card_text", term)
      when "t", "type" then text_match("cards.type_line", term)
      when "c", "color" then color_match(term, default_op: ">=")
      when "ci", "id", "identity", "coloridentity" then color_match(term, default_op: "<=")
      when *STATS.keys then stat_match(term)
      when "m", "mana" then mana_match(term)
      when "s", "set", "e", "edition" then match_one("LOWER(cube_cards.custom_set) = LOWER(?)", term, equality_only: true)
      when "layout" then match_one("LOWER(cards.layout) = LOWER(?)", term, equality_only: true)
      when "is", "has" then is_match(term)
      end
    end

    def sql(template, *binds)
      ActiveRecord::Base.sanitize_sql_array([ template, *binds ])
    end

    def match_one(template, term, equality_only:)
      return nil if equality_only && ![ ":", "=" ].include?(term.op)
      sql(template, term.value)
    end

    def text_match(column, term, name: false)
      return nil unless [ ":", "=" ].include?(term.op)
      if regex?(term.value)
        pattern = term.value[1..-2]
        return valid_regex?(pattern) ? sql("#{column} ~* ?", pattern) : nil
      end
      if name
        value = term.value.delete("'’")
        return exact_name(value) if term.op == "="
        column = NAME
        return value.empty? ? nil : sql("#{column} ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(value)}%")
      end
      sql("#{column} ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(term.value)}%")
    end

    # Whole name, or either face of a "A // B" card
    def exact_name(value)
      sql("(LOWER(#{NAME}) = LOWER(:v) OR LOWER(#{NAME}) LIKE LOWER(:left) OR LOWER(#{NAME}) LIKE LOWER(:right))".gsub(":v", "?").gsub(":left", "?").gsub(":right", "?"),
        value, "#{ActiveRecord::Base.sanitize_sql_like(value)} // %", "% // #{ActiveRecord::Base.sanitize_sql_like(value)}")
    end

    def regex?(value)
      value.length >= 2 && value.start_with?("/") && value.end_with?("/")
    end

    # Postgres runs the pattern, so refuse what it can't safely or sensibly handle
    def valid_regex?(pattern)
      return false if pattern.empty? || pattern.length > MAX_REGEX_LENGTH
      return false if pattern.match?(/\(\?[=!<]|\\[1-9]/)
      return false if (@regex_count += 1) > MAX_REGEXES
      Regexp.new(pattern)
      true
    rescue RegexpError
      false
    end

    def color_match(term, default_op:)
      op = term.op
      return nil unless COMPARISON_OPS.key?(op)
      colors = parse_colors(term.value)
      return nil if colors.nil?

      if colors.is_a?(Integer)
        return "cardinality(#{COLOR}) #{COMPARISON_OPS[op]} #{colors}"
      elsif colors == :multicolor
        return "cardinality(#{COLOR}) #{%w[!= <>].include?(op) ? "<" : ">="} 2"
      end

      op = default_op if op == ":"
      op = "=" if op == default_op && colors.empty? && default_op == ">=" && term.op == ":"
      set = sql("?::varchar[]", "{#{colors.join(",")}}")
      equal = "(#{COLOR} @> #{set} AND #{COLOR} <@ #{set})"
      case op
      when "=" then equal
      when "!=", "<>" then "NOT #{equal}"
      when ">=" then "#{COLOR} @> #{set}"
      when ">" then "(#{COLOR} @> #{set} AND NOT #{equal})"
      when "<=" then "#{COLOR} <@ #{set}"
      when "<" then "(#{COLOR} <@ #{set} AND NOT #{equal})"
      end
    end

    # => uppercase color letters (empty for colorless), an Integer count, :multicolor, or nil
    def parse_colors(value)
      value = value.downcase
      return value.to_i if value.match?(/\A\d+\z/)
      return :multicolor if %w[m multicolor].include?(value)

      letters = COLOR_NAMES.fetch(value, value)
      return [] if letters == "c"
      return nil unless letters.match?(/\A[wubrgc]+\z/)
      letters.delete("c").upcase.chars.uniq
    end

    def stat_match(term)
      op = COMPARISON_OPS[term.op]
      return nil unless op
      column = STATS.fetch(term.key)
      value = term.value.downcase
      if column == MV && %w[even odd].include?(value) && term.op == ":"
        return "#{MV} % 2 = #{value == "even" ? 0 : 1}"
      end
      if STATS.key?(value) # e.g. pow>tou
        return "#{column} #{op} #{STATS.fetch(value)}"
      end
      number = Float(value, exception: false)
      number && sql("#{column} #{op} ?", number)
    end

    # Supports `:`/`>=` (at least these symbols), `>`, `=` (exactly) and `!=`
    def mana_match(term)
      return nil unless [ ":", ">=", ">", "=", "!=", "<>" ].include?(term.op)
      generic, symbols = parse_mana(term.value)
      return nil if generic.zero? && symbols.empty?

      at_least = [ sql("#{GENERIC_IN_COST} >= ?", generic) ] + symbols.tally.map { |symbol, count| sql("#{symbol_count(symbol)} >= ?", count) }
      at_least_sql = "(#{at_least.join(" AND ")})"
      token_total = symbols.size + (generic.zero? ? 0 : 1)
      exactly = "(#{at_least_sql} AND #{sql("#{TOKEN_COUNT_IN_COST} = ?", token_total)} AND #{sql("#{GENERIC_IN_COST} = ?", generic)})"
      case term.op
      when ":", ">=" then at_least_sql
      when ">" then "(#{at_least_sql} AND NOT #{exactly})"
      when "=" then exactly
      else "NOT #{exactly}"
      end
    end

    GENERIC_IN_COST = "COALESCE((SELECT SUM(m[1]::int) FROM regexp_matches(cards.cost, '\\{(\\d+)\\}', 'g') AS m), 0)"
    TOKEN_COUNT_IN_COST = "COALESCE((SELECT COUNT(*) FROM regexp_matches(cards.cost, '\\{[^}]+\\}', 'g') AS m), 0)"

    def symbol_count(symbol)
      sql("((length(cards.cost) - length(replace(cards.cost, ?, ''))) / ?)", symbol, symbol.length)
    end

    # "2ww" or "{2}{W}{W}" or "{r/g}" => [2, ["{W}", "{W}"]]
    def parse_mana(value)
      generic = 0
      symbols = []
      value.scan(/\{([^}]+)\}|(\d+)|([a-z])/i) do |braced, digits, letter|
        text = (braced || digits || letter).upcase
        if text.match?(/\A\d+\z/) then generic += text.to_i
        else symbols << "{#{text}}"
        end
      end
      [ generic, symbols ]
    end

    def is_match(term)
      return nil unless [ ":", "=" ].include?(term.op)
      keyword = term.value.downcase
      return IS_CONDITIONS[keyword] if IS_CONDITIONS.key?(keyword)
      sql("cards.layout = ?", keyword) if IS_LAYOUTS.include?(keyword)
    end
  end
end
