require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#html_lang' do
    it 'returns "en" for default locale' do
      allow(I18n).to receive(:locale).and_return(I18n.default_locale)
      expect(helper.html_lang).to eq('en')
    end

    it 'returns locale string for non-default locale' do
      allow(I18n).to receive(:locale).and_return(:fr)
      allow(I18n).to receive(:default_locale).and_return(:en)
      expect(helper.html_lang).to eq('fr')
    end
  end

  describe '#markdown' do
    context 'with blank text' do
      it 'returns empty string for nil' do
        expect(helper.markdown(nil)).to eq('')
      end

      it 'returns empty string for empty string' do
        expect(helper.markdown('')).to eq('')
      end

      it 'returns empty string for whitespace only' do
        expect(helper.markdown('   ')).to eq('')
      end
    end

    context 'with basic markdown' do
      it 'renders paragraphs' do
        text = 'This is a paragraph.'
        result = helper.markdown(text)
        expect(result).to include('<p>This is a paragraph.</p>')
      end

      it 'renders headers' do
        text1 = '# Header 1'
        text2 = '## Header 2'
        result1 = helper.markdown(text1)
        result2 = helper.markdown(text2)
        expect(result1).to include('<h1>')
        expect(result1).to include('Header 1')
        expect(result2).to include('<h2>')
        expect(result2).to include('Header 2')
      end

      it 'renders bold text' do
        text = '**bold text**'
        result = helper.markdown(text)
        expect(result).to include('<strong>bold text</strong>')
      end

      it 'renders italic text' do
        text = '*italic text*'
        result = helper.markdown(text)
        expect(result).to include('<em>italic text</em>')
      end

      it 'renders strikethrough text' do
        text = '~~strikethrough~~'
        result = helper.markdown(text)
        expect(result).to include('<del>strikethrough</del>')
      end

      it 'renders links' do
        text = '[link text](https://example.com)'
        result = helper.markdown(text)
        expect(result).to include('<a href="https://example.com">link text</a>')
      end

      it 'renders unordered lists' do
        text = "- Item 1\n- Item 2"
        result = helper.markdown(text)
        expect(result).to include('<ul>')
        expect(result).to include('<li>Item 1</li>')
        expect(result).to include('<li>Item 2</li>')
      end

      it 'renders ordered lists' do
        text = "1. First item\n2. Second item"
        result = helper.markdown(text)
        expect(result).to include('<ol>')
        expect(result).to include('<li>First item</li>')
        expect(result).to include('<li>Second item</li>')
      end

      it 'renders code blocks' do
        text = "```ruby\ncode here\n```"
        result = helper.markdown(text)
        expect(result).to include('<pre><code')
        expect(result).to include('code here')
      end

      it 'renders inline code' do
        text = 'This is `inline code`'
        result = helper.markdown(text)
        expect(result).to include('<code>inline code</code>')
      end

      it 'renders tables' do
        text = "| Header 1 | Header 2 |\n|----------|----------|\n| Cell 1   | Cell 2   |"
        result = helper.markdown(text)
        expect(result).to include('<table>')
        expect(result).to include('<th>Header 1</th>')
        expect(result).to include('<td>Cell 1</td>')
      end

      it 'renders blockquotes' do
        text = '> This is a quote'
        result = helper.markdown(text)
        expect(result).to include('<blockquote>')
        expect(result).to include('<p>This is a quote</p>')
      end
    end

    context 'with task lists' do
      it 'renders unchecked task list items' do
        text = '- [ ] Unchecked task'
        result = helper.markdown(text)

        expect(result).to include('<input type="checkbox"')
        expect(result).to include('class="task-list-item-checkbox"')
        expect(result).to include('disabled')
        expect(result).not_to include('checked disabled')
        expect(result).to include('Unchecked task')
      end

      it 'renders checked task list items' do
        text = '- [x] Checked task'
        result = helper.markdown(text)

        expect(result).to include('<input type="checkbox"')
        expect(result).to include('class="task-list-item-checkbox"')
        expect(result).to include('checked disabled')
        expect(result).to include('disabled')
        expect(result).to include('Checked task')
      end

      it 'renders mixed task list items' do
        text = "- [ ] First task\n- [x] Second task\n- [ ] Third task"
        result = helper.markdown(text)

        # Should have 3 checkboxes total
        expect(result.scan(/input type="checkbox"/).length).to eq(3)

        # Should have 1 checked and 2 unchecked
        expect(result.scan(/checked disabled/).length).to eq(1)

        # Should contain all task text
        expect(result).to include('First task')
        expect(result).to include('Second task')
        expect(result).to include('Third task')
      end

      it 'renders indented task list items' do
        text = "- [ ] Parent task\n  - [x] Child task"
        result = helper.markdown(text)

        expect(result).to include('Parent task')
        expect(result).to include('Child task')
        expect(result.scan(/input type="checkbox"/).length).to eq(2)
      end

      it 'handles task lists with other markdown elements' do
        text = "- [x] **Bold** task with `code`\n- [ ] *Italic* task with [link](https://example.com)"
        result = helper.markdown(text)

        expect(result).to include('<strong>Bold</strong>')
        expect(result).to include('<code>code</code>')
        expect(result).to include('<em>Italic</em>')
        expect(result).to include('<a href="https://example.com">link</a>')
        expect(result.scan(/input type="checkbox"/).length).to eq(2)
      end

      it 'does not affect regular list items' do
        text = "- Regular item\n- Another regular item"
        result = helper.markdown(text)

        expect(result).not_to include('input type="checkbox"')
        expect(result).to include('<li>Regular item</li>')
        expect(result).to include('<li>Another regular item</li>')
      end

      it 'handles malformed task list syntax' do
        text = "- [invalid] Not a task\n- [ ] Valid task"
        result = helper.markdown(text)

        # Should only have one checkbox for the valid task
        expect(result.scan(/input type="checkbox"/).length).to eq(1)
        expect(result).to include('[invalid] Not a task')
        expect(result).to include('Valid task')
      end
    end

    context 'with security considerations' do
      it 'filters dangerous HTML' do
        text = '<script>alert("xss")</script>'
        result = helper.markdown(text)

        expect(result).not_to include('<script>')
        expect(result).not_to include('alert("xss")')
      end

      it 'allows safe HTML elements' do
        text = 'This is **bold** and *italic*'
        result = helper.markdown(text)

        expect(result).to include('<strong>bold</strong>')
        expect(result).to include('<em>italic</em>')
      end

      it 'sanitizes malicious links' do
        text = '[bad link](javascript:alert("xss"))'
        result = helper.markdown(text)

        # The link should either be removed or sanitized, not contain javascript:
        expect(result).not_to include('href="javascript:')
      end
    end

    context 'with edge cases' do
      it 'handles very long text' do
        long_text = 'a' * 10000
        result = helper.markdown(long_text)

        expect(result).to include('<p>')
        expect(result.length).to be > 10000
      end

      it 'handles unicode characters' do
        text = '# 🚀 Unicode Header\n\nText with émojis and spëcial chars'
        result = helper.markdown(text)

        expect(result).to include('🚀 Unicode Header')
        expect(result).to include('émojis and spëcial chars')
      end

      it 'handles mixed line endings' do
        text = "Line 1\r\nLine 2\nLine 3"
        result = helper.markdown(text)

        expect(result).to include('Line 1')
        expect(result).to include('Line 2')
        expect(result).to include('Line 3')
      end
    end
  end

  describe '#process_task_lists_in_html' do
    it 'is a private method' do
      expect(helper.private_methods).to include(:process_task_lists_in_html)
    end
  end
end
