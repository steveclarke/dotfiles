# frozen_string_literal: true

# Reduces markdown to the prose a reader reads, so the scorers measure sentences
# rather than code, tables and link targets. Both scorers use it with --markdown.
#
# - Drops front matter, fenced code, tables and HTML tags.
# - Keeps link text and drops link targets and bare URLs.
# - Drops headings, which are labels rather than sentences.
# - Ends each list item with a period, because a run of unpunctuated bullets
#   otherwise counts as one very long sentence.
module MarkdownProse
  BLOCK_MARKER = /^\s*([-*+]|\d+[.)]|>)\s+/

  module_function

  def extract(text)
    text = text.sub(/\A---\n.*?\n---\n/m, "")
    text = text.gsub(/^(```|~~~).*?^\1[^\n]*$/m, "")
    lines = text.lines.map(&:chomp).reject { |line| line.match?(/^\s*(\||#+\s)/) }

    lines.map { |line| prose_line(line) }.join("\n")
  end

  def prose_line(line)
    line = line.gsub(/!?\[([^\]]*)\]\([^)]*\)/, '\1')
      .gsub(%r{https?://\S+}, "")
      .gsub(/<[^>]+>/, "")
      .gsub(/`([^`]*)`/, '\1')
      .gsub(/[*_]{1,3}/, "")
    return line unless line.match?(BLOCK_MARKER)

    line = line.sub(BLOCK_MARKER, "").strip
    line.empty? || line.match?(/[.!?:]$/) ? line : "#{line}."
  end
end
