module ApplicationHelper
  # Formats learning body text:
  # - Escapes existing HTML.
  # - Bolds lines starting with keywords like Context:, Resolution:, Learning:, etc.
  # - Wraps text in backticks (`) with <code> tags.
  # - Converts newlines to <br> and double newlines to <p> tags using simple_format.
  def format_learning_body(text)
    # 1. Escape all potentially harmful HTML first
    escaped_text = ERB::Util.html_escape(text)

    # 2. Bold specific keywords at the start of lines
    bolded_text = escaped_text.gsub(/^(Action:|Context:|Resolution:|Learning:|Details:|Issue:|Observation:|Cause:|Decision:|Alternative Considered:)/) do |match|
      "<strong>#{match}</strong>"
    end

    # 3. Wrap text enclosed in backticks with <code> tags
    # Uses non-greedy match `(.+?)` to handle multiple instances per line
    code_tagged_text = bolded_text.gsub(/`(.+?)`/) do |_match|
      "<code>#{$1}</code>" # $1 contains the text captured between the backticks
    end

    # 4. Apply simple_format, keeping our added <strong> and <code> tags
    simple_format(code_tagged_text, {}, sanitize: false)
    # REASON: Added sanitize: false because the source text (LEARNINGS.md) is trusted
    # and contains backticks (`) for code formatting, which would otherwise be stripped.
    # If the source was user input, sanitization would be crucial.
  end
end