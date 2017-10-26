class SendMessagesController < ApplicationController

  #群发短信
  # group_hash sample
  # {message:"UBC第一个提货点", key: "2136"}
  # {message:"UBC第一个提货点", key: "2136"},
  # {message:"UBC第二个提货点", key: "Forestry"},
  # {message:"UBC第二个提货点", key: "Bookstores"},
  # {message:"Uhill提货点", key: "Uhill"},
  def send_group_message
    group_hash = params[:group_hash]
    my_date = Time.now.strftime("%Y%m%d")
    number_arr = Myjson.where(["form_name LIKE ?", "%#{my_date}%"]).where(["address LIKE ?", "%#{group_hash[:key]}%"]).pluck(:phone).uniq
    send_message(number_arr, "您好, 我们到了#{group_hash[:message]}了, 请您来取. 送货员电话: 7783007960")


    #redirect_to url_for(:controller => "jsons", :action => :index)
    redirect_to jsons_path


  end


  #send message to one number
  def send_message(number_arr,message)
    # put your own credentials here
    #number_arr, my_message

    account_sid =  ENV["twilio_account_sid"]
    auth_token = ENV["twilio_auth_token"]
    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token


    number_arr.each do |number|
      begin
        @client.api.account.messages.create(
            from: '+12892761834',
            to: number,
            body: message
        )
      rescue => err
        puts "********************send msg error********************"
        puts err.message
        puts "********************send msg error********************"
      end

    end

  end

end


