#encoding: utf-8

module CheckAlert
  def check_alert_rate(universe)
    # get rate the argument currency
    array_scrape_info = Acquirer.scrape_for_alert_rate(universe)
    # get settings the argument currency
    array_alert_setting = Alerts.get_all_unchecked_alerts(universe)
    # get settings the argument currency
    if array_alert_setting.present?
      compare_rate_with_setting(array_scrape_info,array_alert_setting)
    end
  end  

  def compare_rate_with_setting(array_scrape_info,array_alert_setting)
    # set the border rate from bid and ask
    border_rate = (((array_scrape_info[:ask_price]).to_f + (array_scrape_info[:bid_price]).to_f) /2)
    array_alert_setting.each do |row|
      if (row[:checkrule] == '0' && border_rate > (row[:alertvalue]).to_f )||(row[:checkrule] == '1' && border_rate < (row[:alertvalue]).to_f ) then
        store_result_to_alertmail(row, border_rate)
        update_alert_status(row)
      end
    end
  end 
  
  def store_result_to_alertmail(row,border_rate)
    # initialize
    if row[:checkrule] == '0' then
      condition_str = "以上"
    elsif row[:checkrule] == '1' then
      condition_str = "以下"
    end
    
    d        = DateTime.now
    datetime = d.strftime("%Y/%m/%d %H:%M")
      
    subject     = "レートアラート:" + row[:code] +" "+datetime
    from        = "mailfromassetcontrol@gmail.com"
    to          = User.find_by_sql(["select email from users where id = ? ", row[:user_id]])[0][:email]
    user_id     = row[:user_id]
    body        = row[:code] + "が" + row[:alertvalue] + condition_str + "になりました。"
    body1       = row[:memo]
    #body2      = 
    status      = '0'
   
    # insert mail info to database
    AlertMail.create!(
        :body => body, 
        :body1 => body1, 
        :from => from,
        :to => to, 
        :user_id => user_id, 
        :subject => subject,
        :status => status,
        )
  end
  
  def update_alert_status(row)
    @Alert = Alerts.find_by_id(row[:id])
    @Alert.attributes = {
        :status => '1'
    }
    @Alert.save!    
  end
  
  def reflect_pivot_to_alert(universe, user_id)
    array_scrape_info = Acquirer.scrape_for_alert_rate(universe)
    cur_code = universe.security_code[0..2]+'/'+universe.security_code[3..5]
    pivot = Pivot.find_by_sql(["select calc_date, cur_code, cycle, P, R1, R2, R3, S1, S2, S3 from pivots
      where cur_code = ?
      order by calc_date desc
      limit 1
      ", cur_code])
    unless pivot.empty? then
      compare_rate_with_technical(array_scrape_info, pivot.first.P, 'Pivot P', user_id, universe.security_code, pivot.first.calc_date)
      compare_rate_with_technical(array_scrape_info, pivot.first.R1, 'Pivot R1', user_id, universe.security_code, pivot.first.calc_date)
      compare_rate_with_technical(array_scrape_info, pivot.first.R2, 'Pivot R2', user_id, universe.security_code, pivot.first.calc_date)
      compare_rate_with_technical(array_scrape_info, pivot.first.R3, 'Pivot R3', user_id, universe.security_code, pivot.first.calc_date)
      compare_rate_with_technical(array_scrape_info, pivot.first.S1, 'Pivot S1', user_id, universe.security_code, pivot.first.calc_date)
      compare_rate_with_technical(array_scrape_info, pivot.first.S2, 'Pivot S2', user_id, universe.security_code, pivot.first.calc_date)
      compare_rate_with_technical(array_scrape_info, pivot.first.S3, 'Pivot S3', user_id, universe.security_code, pivot.first.calc_date)
    end
  end
  
  def reflect_bb_to_alert(universe, user_id)
    array_scrape_info = Acquirer.scrape_for_alert_rate(universe)
    cur_code = universe.security_code[0..2]+'/'+universe.security_code[3..5]
    bb = BolingerBand.find_by_sql(["select calc_date, cur_code, term, MA, plus1sigma, plus2sigma, plus3sigma, minus1sigma, minus2sigma, minus3sigma from bolinger_bands
      where cur_code = ?
      order by calc_date desc
      limit 1
      ", cur_code])
    unless bb.empty? then      
      compare_rate_with_technical(array_scrape_info, bb.first.plus1sigma, "BolingerBand +1σ", user_id, universe.security_code, bb.first.calc_date)
      compare_rate_with_technical(array_scrape_info, bb.first.plus2sigma, "BolingerBand +2σ", user_id, universe.security_code, bb.first.calc_date)
      compare_rate_with_technical(array_scrape_info, bb.first.plus3sigma, "BolingerBand +3σ", user_id, universe.security_code, bb.first.calc_date)
      compare_rate_with_technical(array_scrape_info, bb.first.minus1sigma, "BolingerBand -1σ", user_id, universe.security_code, bb.first.calc_date)
      compare_rate_with_technical(array_scrape_info, bb.first.minus2sigma, "BolingerBand -2σ", user_id, universe.security_code, bb.first.calc_date)
      compare_rate_with_technical(array_scrape_info, bb.first.minus3sigma, "BolingerBand -3σ", user_id, universe.security_code, bb.first.calc_date)
      compare_rate_with_technical(array_scrape_info, bb.first.MA, "BolingerBand 25MA", user_id, universe.security_code, bb.first.calc_date)
    end
  end

  def reflect_ma_to_alert(universe, user_id)
    # define each item codes
    item_avg_rate_25d    = Settings[:item_fx][:rate_25d_avg]
    item_avg_rate_75d    = Settings[:item_fx][:rate_75d_avg]
    item_avg_rate_100d   = Settings[:item_fx][:rate_100d_avg]
    item_avg_rate_200d   = Settings[:item_fx][:rate_200d_avg]
    
    # define array for loop procedure
    array_ma = [
      ['25MA',item_avg_rate_25d],
      ['75MA',item_avg_rate_75d],
      ['100MA',item_avg_rate_100d],
      ['200MA',item_avg_rate_200d]
    ]

    array_scrape_info = Acquirer.scrape_for_alert_rate(universe)
    cur_code = universe.security_code[0..2]+'/'+universe.security_code[3..5]

    if cur_code[4..6] == 'JPY'
      digits = 3
    else
      digits = 5
    end

    # calculate avg of daily range for past 5 day
    array_ma.each do |technical_name, item_code|
      ma = BolingerBand.find_by_sql(["select calc_date, cur_code, item, round(data, ?) as data from fx_performances 
        where cur_code = ? 
        and item = ? 
        order by calc_date desc 
        limit 1
        ", digits, cur_code, item_code])
      unless ma.empty? then      
        compare_rate_with_technical(array_scrape_info, ma.first.data, technical_name, user_id, universe.security_code, ma.first.calc_date)
      end
    end
  end
  
  def compare_rate_with_technical(array_scrape_info, data, technical_name, user_id, cur_code, calc_date)
    border_rate = (((array_scrape_info[:ask_price]).to_f + (array_scrape_info[:bid_price]).to_f) /2)
    
    if border_rate < data.to_f
      checkrule = 0
    else
      checkrule = 1
    end    
    Alerts.create!(
        :user_id => user_id, 
        :code => cur_code,
        :alertvalue => data, 
        :memo => '[自動設定]'+technical_name+':'+data.to_s+'('+calc_date+')', 
        :checkrule => checkrule,
        :status => '0'
        )    
  end 

end