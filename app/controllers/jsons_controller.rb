require 'net/http'
require 'json'
require 'twilio-ruby'

class JsonsController < ApplicationController
  skip_before_action :verify_authenticity_token


  #http://localhost:3000/jsons
  def index

    # for test message
    # send_message(['(+1)778-300-7960'])

    my_date = Time.now.strftime("%Y%m%d")
    #
    # Myjson.where(["form_name LIKE ?", "%#{my_date}%"]).pluck(:phone).uniq


    @orders = Myjson.where(["form_name LIKE ?", "%#{my_date}%"]).order(:address)

  end

  #http://localhost:3000/jsons
  def create
    respond_to do |format|
      # format.html {render :inline => "test"}
      # format.json { render :json => @post }
      format.json {
        hash_response = JSON.parse(params[:json].to_json)

        puts '************************'
        puts hash_response
        puts '************************'


        #form = form unique name
        form = hash_response["form"]
        #form_name = chinese name of form
        form_name = hash_response["form_name"]
        order_id = hash_response["entry"]["serial_number"]
        price = hash_response["entry"]["total_price"]
        product1_arr = hash_response["entry"]["field_11"]

        #prodcut1 = meal
        product1 = ""
        product1_arr.each do |product|
          product1 += product["name"] +" X "+ product["number"].to_s + "; "
        end

        #prodcut2 = snack
        product2_arr = hash_response["entry"]["field_26"]
        product2 = ""
        product2_arr.each do |product|
          product2 += product["name"] +" X "+ product["number"].to_s+ "; "
        end

        name = hash_response["entry"]["field_21"]
        phone = hash_response["entry"]["field_23"]
        email = hash_response["entry"]["field_20"]
        comment = hash_response["entry"]["field_18"]
        address = hash_response["entry"]["field_16"]
        payment = hash_response["entry"]["field_25"]

        # model Myjson
        j = Myjson.new
        j.form_name=form_name
        j.form = form
        j.order_id = order_id
        j.price = price
        j.product1 = product1
        j.product2 = product2
        j.name = name
        j.phone = phone
        j.email = email
        j.comment = comment
        j.address = address
        j.payment = payment


        if (j.save)
          puts "save successful"
          my_message = "尊敬的" + j.name + ", 您成功订购" + j.product1 + j.product2 + ", 总共金额" + j.price.to_s + '加币, haochi.ca 感谢您的购买. 此短信系统自动发送, 请勿回复.'
          send_message([j.phone], my_message)
          # send_message(['7783007960'], my_message)
        end


        # puts hash_response
        render :inline => "test"
      }

    end


  end


  private def send_message(number_arr, my_message)
    # put your own credentials here
    account_sid =  ENV["twilio_account_sid"]
    auth_token = ENV["twilio_auth_token"]

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    number_arr.each do |number|
      begin
        @client.api.account.messages.create(
            from: '+12892761834',
            to: number,
            body: my_message
        )
      rescue => err
        logger.error err.message
      end


    end


  end


end


# my_date = Time.now.strftime("%Y%m%d")
#
# Myjson.where(["form_name LIKE ?", "%#{my_date}%"]).pluck(:phone).uniq
#
# #Uhill提货点
# Myjson.where(["form_name LIKE ?", "%#{my_date}%"]).where(["address LIKE ?", "%Uhill%"]).pluck(:phone).uniq
# #UBC第一个提货点
# Myjson.where(["form_name LIKE ?", "%#{my_date}%"]).where(["address LIKE ?", "%2136%"]).pluck(:phone).uniq
# #UBC第二个提货点
# Myjson.where(["form_name LIKE ?", "%#{my_date}%"]).where(["address LIKE ?", "%Forestry%"]).pluck(:phone).uniq
# #UBC第三个提货点
# Myjson.where(["form_name LIKE ?", "%#{my_date}%"]).where(["address LIKE ?", "%Bookstores%"]).pluck(:phone).uniq
