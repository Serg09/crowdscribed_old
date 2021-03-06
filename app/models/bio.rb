# == Schema Information
#
# Table name: bios
#
#  id         :integer          not null, primary key
#  author_id  :integer          not null
#  text       :text             not null
#  photo_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  links      :text
#  status     :string           default("pending"), not null
#

class Bio < ActiveRecord::Base
  include Approvable

  before_save :process_photo_file, if: :photo_file

  belongs_to :author, polymorphic: true
  belongs_to :photo, class_name: Image
  validates_associated :links
  serialize :links, Link
  validates_presence_of :author_id, :author_type, :text
  
  attr_accessor :photo_file

  def self.browsable
    sql = <<-EOS
      (select
        bios.*,
        authors.first_name,
        authors.last_name
      from bios
        inner join authors on authors.id = bios.author_id
          and bios.author_type = 'Author'
      where bios.status = 'approved'
      union
      select
        bios.*,
        users.first_name,
        users.last_name
      from bios
        inner join users on users.id = bios.author_id
          and bios.author_type = 'User'
      where bios.status = 'approved'
      order by last_name, first_name) as bios
    EOS
    from sql
  end

  def links_attributes=(list)
    if list
      self.links = list.map do |attr|
        Link.new(attr)
      end
    else
      self.links = []
    end
  end

  def usable_links
    links.select{|link| link.url.present?}
  end

  def visible_to_public?
    approved?
  end

  def visible_to_owner?
    !rejected?
  end

  private

  def process_photo_file
    image = Image.find_or_create_from_file(photo_file, author)
    self.photo_id = image.id
  end

  def current_version
    author.active_bio
  end
end
