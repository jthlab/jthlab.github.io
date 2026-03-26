require "bibtex"

bibtex_spec = Gem.loaded_specs["bibtex-ruby"]

if bibtex_spec && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.2") && bibtex_spec.version < Gem::Version.new("6.0.0")
  module BibTeX
    class Bibliography
      # Ruby 3.2 no longer supports implicit Proc.new block capture here.
      def each(&block)
        if block
          data.each(&block)
          self
        else
          to_enum
        end
      end

      def unify(field, pattern, value = nil, &block)
        pattern = Regexp.new(pattern) unless pattern.is_a?(Regexp)
        block ||= proc { |entry| entry[field] = value }

        each_entry do |entry|
          block.call(entry) if entry.field?(field) && entry[field].to_s =~ pattern
        end

        self
      end

      def each_entry(&block)
        if block
          q("@entry").each(&block)
        else
          q("@entry").to_enum
        end
      end

      def select_duplicates_by(*arguments, &block)
        arguments = %i[year title] if arguments.empty?

        group_by(*arguments) do |digest, entry|
          digest.gsub(/\s+/, "").downcase
          digest = block.call(digest, entry) if block
          digest
        end.values.select { |duplicates| duplicates.length > 1 }
      end

      alias duplicates select_duplicates_by
    end

    class Entry
      def each(&block)
        if block
          fields.each(&block)
          self
        else
          to_enum
        end
      end

      alias each_pair each

      def convert(*filters, &block)
        block ? dup.convert!(*filters, &block) : dup.convert!(*filters)
      end
    end
  end
end
