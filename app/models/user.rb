class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sent_messages,      :foreign_key => :sender,   :class_name => 'Message'
  has_many :received_messages,  :foreign_key => :receiver, :class_name => 'Message'

  def conversation_with(user_id)
    Message.where("sender_id = #{self.id} AND receiver_id = #{user_id} OR sender_id = #{user_id} AND receiver_id = #{self.id}").order(created_at: :desc)
  end

  def all_but_this
    User.where.not(id: self.id)
  end

  def unread_messages(user_id)
    self.received_messages.where(sender: user_id).where(read: false).count
  end
end
