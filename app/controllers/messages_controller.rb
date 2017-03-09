class MessagesController < ApplicationController
  def index
    @users = User.where.not(id: current_user)
  end

  def create
    @message = Message.new(params.require(:message).permit(:text))
    @message.text = @message.text.strip
    if (@message.text.length > 0)
      @message.sender = current_user
      @message.receiver_id = params[:id]
      @message.save
      respond_to do |format|
        format.html { redirect_to @message, notice: 'Message successfully sent.' }
        format.js   { }
      end
    else
      respond_to do |format|
        format.html { redirect_to @message, alert: 'Can\'t send empty message.' }
        format.js   { render template: 'messages/empty.js.erb', layout: false }
      end
    end
  end

  def show
    @users = User.where.not(id: current_user)
    @messages = Message.where("sender_id = #{current_user.id} AND receiver_id = #{params[:id]} OR sender_id = #{params[:id]} AND receiver_id = #{current_user.id}").order(created_at: :asc)
    @messages.where(receiver_id: current_user.id).update_all("read = true")
  end
end
