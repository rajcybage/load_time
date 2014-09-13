require 'open-uri'
require 'date'
require 'win32ole'
class UrlsController < ApplicationController
  before_filter :authenticate_user!
  # GET /urls
  # GET /urls.json
  def index
    @urls = Url.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @urls }
    end
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
    @url = Url.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @url }
    end
  end

  # GET /urls/new
  # GET /urls/new.json
  def new
    @url = Url.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @url }
    end
  end

  # GET /urls/1/edit
  def edit
    @url = Url.find(params[:id])
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = current_user.urls.new(params[:url])

    respond_to do |format|
      if @url.save
        format.html { redirect_to urls_path, notice: 'Url was successfully created.' }
        format.json { render json: @url, status: :created, location: @url }
      else
        format.html { render action: "new" }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /urls/1
  # PUT /urls/1.json
  def update
    @url = Url.find(params[:id])

    respond_to do |format|
      if @url.update_attributes(params[:url])
        format.html { redirect_to @url, notice: 'Url was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url = Url.find(params[:id])
    @url.destroy

    respond_to do |format|
      format.html { redirect_to urls_url }
      format.json { head :no_content }
    end
  end

  def calculate_load_time
    @url = Url.where(url_name: params[:url]).first
    begin 
      start = Time.new
      f = open(params[:url]).read
      stop = Time.new
      exact_time = stop - start
    rescue 
      start = Time.new
      f = open(params[:url].gsub("http", "https")).read
      stop = Time.new
      exact_time = stop - start
    end  
    @url.update_column(:calculated_time, exact_time.to_i)
    send_mail(params[:url]) if exact_time >= @url.threshold_value
    redirect_to urls_path  
  end  

  private

  def send_mail(url)
    outlook = WIN32OLE.new('Outlook.Application')
    message = outlook.CreateItem(0)
    message.Subject = "The Page load more than threshold time"
    message.Body = "The url which load more than threshold value is:" + url
    message.Recipients.Add current_user.email
    # message.Recipients.Add 'cat@dog.com'
    # message.Attachments.Add('C:\Path\To\File.txt')
    #Want to save as a draft?
    message.Save
    #Want to send instead?
    message.Send

  end  
end
