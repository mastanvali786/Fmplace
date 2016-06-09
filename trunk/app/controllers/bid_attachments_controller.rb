class BidAttachmentsController < ApplicationController

  def destroy
    attachment = BidAttachment.find params[:id]
    attachment.delete
    render json: {success:true, id: attachment.id}
  end
end
