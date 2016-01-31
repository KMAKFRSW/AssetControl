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

end