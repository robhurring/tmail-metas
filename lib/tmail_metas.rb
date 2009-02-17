module TMail
  module Metas
    # Looks for {{key=value[&something=value]}} pairs within the mail's body by default
    @@meta_tag_scanner = /\s*\{\{\s*(.*)\s*\}\}\s*/m
    # group_seperator:: what break each key,value pair
    # seperator:: what breaks keys and values apart
    @@meta_scanner_options = {
      :group_seperator => '&', 
      :seperator => '='
      }
    def self.scanner=(scanner); @@meta_tag_scanner = scanner end
    def self.scanner_options=(options); @@meta_scanner_options = options end
    def metas
      @metas ||= Hash[*$1.split(@@meta_scanner_options[:group_seperator]).map do |group| 
        group.split(@@meta_scanner_options[:seperator]).map(&:strip)
      end.flatten] if body =~ @@meta_tag_scanner
      self.body = body.gsub(@@meta_tag_scanner, '')
      @metas
    end
  end
end
TMail::Mail.send(:include, TMail::Metas)