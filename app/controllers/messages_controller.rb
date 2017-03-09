class MessagesController < ApplicationController
  def index
    @users = current_user.all_but_this
    current_user.conversation_with(params[:id])
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
    raise ActiveRecord::RecordNotFound unless User.exists(params[:id])
    @users = current_user.all_but_this
    @messages = current_user.conversation_with(params[:id])
    @messages.where(receiver_id: current_user.id).update_all("read = true")
  end
end
