class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :itineraries
  has_one_attached :avatar
  has_many :purchases

  def has_purchased?(attraction)
    purchases.exists?(attraction: attraction)
  end

end
