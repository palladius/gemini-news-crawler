
class ChatsController < ApplicationController

# breaks PROD!
#   protect_from_forgery with: :null_session


#     def create
#       CarlessianChat = Data.define(:user, :msg) rescue nil
#       @turbo_stream = false # Disable Turbo for this action
#       message = params[:message]
#       puts("🤷🏼‍♀️🤷🏼‍♀️ ChatsController::Create 🤷🏼‍♀️🤷🏼‍♀️ message='#{message}'")
#       puts("🤷🏼‍♀️🤷🏼‍♀️ ChatsController::Create 🤷🏼‍♀️🤷🏼‍♀️ params='#{params}'")
#       llm_response = "TODO Call your LLM to get the response based on '''#{message}'''"
#       # TODO move to
#       render json: { user_message: message, llm_response: llm_response }
#     end

#   def index
#     #@message = '42'
#   end

end
