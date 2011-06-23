require "contentable/version"

module Contentable
  def contentable
    include InstanceMethods
    has_one :content, :as => :contentable, :autosave => true
    alias_method_chain :content, :autobuild
    delegate :body, :content_type, :content_type=, :render, :to => :content
    validate :content_must_be_valid
  end

  module InstanceMethods
    def content_with_autobuild
      content_without_autobuild || build_content
    end

    def body=(val)
      content.body = val
      self[:updated_at] = current_time_from_proper_timezone
    end

    protected

    def content_must_be_valid
      return if content.valid?
      content.errors.each { |attr, msg| errors.add(attr, msg) }
    end
  end
end

if defined?(Rails)
  ActiveRecord::Base.extend(Contentable)
end