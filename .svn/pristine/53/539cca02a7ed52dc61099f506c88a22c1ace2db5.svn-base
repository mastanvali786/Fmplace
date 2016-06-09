class AdvertisementsController < ApplicationController
  before_filter :authenticate_user!, except: [:click_on_ads, :all_advertisements]
  def new
    if current_user.balance.amount.zero?
      flash[:error] = "Please Deposit to get this service"
      redirect_to advertisements_path
    else
       @advertisement = Advertisement.new
    end
  end

  def index
    @advertisements = current_user.advertisements.order('updated_at DESC').page(params[:page]).per(PER_PAGE_COUNT)
  end

  def edit
    @advertisement = Advertisement.find_by_id(params[:id])
  end

  def create
    @ads = Advertisement.new(advertisement_params)
    if params[:advertisement][:show_continuously] == true
      @advertisement.stop_date = "nil"
    end
    if @ads.save
      flash[:notice] = ' Campaign created successfully.'
    	redirect_to advertisements_path
    else
    	render 'new'
    end
  end

  def update
    @advertisement = Advertisement.find_by_id(params[:id])
    if params[:advertisement][:show_continuously] == true
      @advertisement.stop_date = nil
    end
    @advertisement.update(advertisement_params)
    flash[:notice] = ' Campaign updated successfully.'
    redirect_to advertisements_path
  end


  def destroy
    @advertisement = Advertisement.find_by_id(params[:id])
    @advertisement.destroy
    flash[:notice] = ' Campaign deleted successfully.'
    redirect_to advertisements_path
  end

  def click_on_ads
    @adv = Advertisement.find_by_id(params[:advertisement_id])
    if @adv.paid_click?
      @adv.increment!(:no_of_clicks)
      ad_click = @adv.ads_click_infos.create(ip:session[:ip], country_code: session[:country_code], country_name: session[:country_name],
       region_code: session[:region_code], region_name: session[:region_name], city: session[:city], zip_code: session[:zip_code],
       time_zone: session[:time_zone], latitude: session[:latitude], longitude: session[:longitude], click_date: Time.now)
      if ad_click
        balance = @adv.user.balance
        if balance.can_withdraw?(@adv.budget_per_click)
          balance.amount = balance.amount - @adv.budget_per_click
          balance.save
          if balance
            @payment = Payment.create(to: @adv.user.id, type: 'Debit', klass: 'AddProposal', amount: @adv.budget_per_click,
             approvedOn: Time.now, approved: true, approvedBy: -1,)
            @payment.feature_transaction
            @payment ? true : false
          end
        else
          false
        end
      end
    end
    render json: {status: true, url: @adv.ad_url}
  end

  def remove_banner
    adv = Advertisement.find_by_id(params[:advertisement_id])
    adv.remove_banner_photo!
    adv.remove_banner_photo = true
    adv.save
    redirect_to :back
  end

  def make_active_inactive
    adv = Advertisement.find_by_id(params[:advertisement_id])
    if adv.status
      adv.update_attribute(:status,false)
      flash[:notice] = "Advertisement paused successfully."
    else
      adv.update_attribute(:status,true)
      flash[:notice] = "Advertisement activated successfully."
    end
    redirect_to :back
  end

  def all_advertisements
    @advertisements = Advertisement.joins(:user).joins(:balance).where("amount > ?", "user.advertisement.budget_per_day").active_ads.where('stop_date >= ? OR stop_date IS NULL', DateTime.now).order('updated_at DESC')
    if @advertisements.present?
      @wday_advertisements = @advertisements.select{|z| z.days_week.split(",").map(&:to_i).include?(DateTime.now.wday)}
      @all_day_advertisements = @advertisements.select{|z| z.days_week.empty? }
      if @wday_advertisements.present?
        @all_advertisements = @all_day_advertisements.concat(@wday_advertisements)
        @advertisements = @all_advertisements.select{|x| x.paid_click? }
      else
        @advertisements = @all_day_advertisements.select{|x| x.paid_click? }
      end
    else
      return false
    end
  end

  private

  def advertisement_params
    params.require(:advertisement).permit(:campaign_name,:ad_title,:ad_content, :ad_url, :banner_photo,
     :show_continuously,:stop_date,:days_week,:ad_sections_ids, :keywords, :budget_per_click, :budget_per_day,
     :user_id)
  end
end

