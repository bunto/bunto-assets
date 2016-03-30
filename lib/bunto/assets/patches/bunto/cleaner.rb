# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2016-present - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Bunto
  class Cleaner
    alias _old_obsolete_files obsolete_files
    def obsolete_files
      _old_obsolete_files.delete_if do |path|
        path =~ %r!\A#{Regexp.escape(site.in_dest_dir("assets"))}(\/.*)?\Z!
      end
    end
  end
end
