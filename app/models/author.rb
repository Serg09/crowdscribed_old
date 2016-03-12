# == Schema Information
#
# Table name: authors
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string           not null
#  first_name             :string           not null
#  last_name              :string           not null
#  phone_number           :string
#  contactable            :boolean          default(FALSE), not null
#  package_id             :integer
#  status                 :string(10)       default("pending"), not null
#

class Author < ActiveRecord::Base
  include Approvable

  has_many :bios
  has_many :books
  has_many :campaigns, through: :books

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  validates_presence_of :first_name, :last_name, :username
  validates_uniqueness_of :username

  def full_name
    "#{first_name} #{last_name}"
  end

  def active_bio
    bios.approved.first
  end

  def pending_bio
    bios.pending.first
  end

  def working_bio
    pending_bio || active_bio
  end
end
