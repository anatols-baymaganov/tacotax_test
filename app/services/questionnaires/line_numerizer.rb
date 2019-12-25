# frozen_string_literal: true

module Questionnaires
  class LineNumerizer
    DELIMITER = "-"

    class << self
      def call(file)
        numerized = StringIO.new
        file.read.split("\n").each_with_index do |line, index|
          next if line.blank? || line.strip.start_with?("#")

          origin_key = line.split(":").first.strip
          quote = origin_key.first.in?(%w[' "]) ? origin_key.first : ""
          numerized << line && next if incorrect_key?(origin_key, quote)

          numerized.puts(line.gsub(/#{origin_key}/, new_key(origin_key, index.next, quote)))
        end
        numerized.pos = 0
        numerized
      end

      private

      def incorrect_key?(origin_key, quote)
        origin_key.blank? || quote.present? && (origin_key.length < 2 || origin_key.first != origin_key.last)
      end

      def new_key(origin_key, line, quote)
        [quote, origin_key.gsub(/\A[',"]|[',"]\Z/, ""), DELIMITER, line, quote].join
      end
    end
  end
end
