#encoding: utf-8

module Technical_Indicator
  def calc_bolinger_band(cur_code, term, calc_date)
    ##############################################################
    # calc following performance items :                         #
    #     bolinger band (25MA, 1σ, 2σ, 3σ, -1σ, -2σ, 3σ)         #
    ##############################################################
    
    # make some arrays for each terms
    bolinger_band     = Array.new

    # get max 60 months rates and store them into array sorting product_code2 and trade_date order
    bolinger_band = FxRate.find_by_sql(["select Y.avg as MA, (Y.avg + Y.sigma) as plus1sigma, (Y.avg + 2*Y.sigma) as plus2sigma, (Y.avg + 3*Y.sigma) as plus3sigma
      , (Y.avg - Y.sigma) as minus1sigma, (Y.avg - 2*Y.sigma) as minus2sigma, (Y.avg - 3*Y.sigma) as minus3sigma from ( 
          select X.product_code2, avg(X.close_price) as avg, STDDEV_POP(X.close_price) as sigma from (
              select * from fx_rates
              where product_code2 = ?
              and trade_date <= ?
              order by trade_date desc
              limit ?
          ) as X
      ) as Y", cur_code, calc_date, term])
    
    if BolingerBand.exists?({ :cur_code => cur_code, :calc_date => calc_date, :term => term })
        @BolingerBand = BolingerBand.find_by_cur_code_and_calc_date_and_term(cur_code, calc_date, term )
        @BolingerBand.attributes = {
            :MA         => sprintf( "%.3f", bolinger_band.first.MA),
            :plus1sigma => sprintf( "%.3f", bolinger_band.first.plus1sigma),
            :plus2sigma => sprintf( "%.3f", bolinger_band.first.plus2sigma),
            :plus3sigma => sprintf( "%.3f", bolinger_band.first.plus3sigma),
            :minus1sigma => sprintf( "%.3f", bolinger_band.first.minus1sigma),
            :minus2sigma => sprintf( "%.3f", bolinger_band.first.minus2sigma),
            :minus3sigma => sprintf( "%.3f", bolinger_band.first.minus3sigma)
        }
        @BolingerBand.save!
    else
      BolingerBand.create!(
          :cur_code  => cur_code,
          :calc_date => calc_date,
          :term      => term,
          :MA         => sprintf( "%.3f", bolinger_band.first.MA),
          :plus1sigma => sprintf( "%.3f", bolinger_band.first.plus1sigma),
          :plus2sigma => sprintf( "%.3f", bolinger_band.first.plus2sigma),
          :plus3sigma => sprintf( "%.3f", bolinger_band.first.plus3sigma),
          :minus1sigma => sprintf( "%.3f", bolinger_band.first.minus1sigma),
          :minus2sigma => sprintf( "%.3f", bolinger_band.first.minus2sigma),
          :minus3sigma => sprintf( "%.3f", bolinger_band.first.minus3sigma)
          )
    end
  end  

  def calc_rsi(cur_code, term, calc_date)
    ##############################################################
    # calc following performance items :                         #
    #     rsi for argument term                                  #
    ##############################################################
    
    # make some arrays for each terms
    rsi     = Array.new

    # calc rsi for indicated term and currencies
    rsi = FxRate.find_by_sql(["select (rise.total/(rise.total + down.total)*100) as RSI from (
    select X.product_code2, ABS(SUM(X.changes)) as total from (
        select product_code2, (close_price - prev_price) as changes from fx_rates 
        where product_code2 = ?
        and trade_date <= ?
        order by trade_date desc
        limit ?
        ) X
    where X.changes > 0 
    ) as rise ,(
    select X.product_code2, ABS(SUM(X.changes)) as total from (
        select product_code2, (close_price - prev_price) as changes from fx_rates 
        where product_code2 = ?
        and trade_date <= ?
        order by trade_date desc
        limit ?
        ) X
    where X.changes < 0 
    ) as down", cur_code, calc_date, term, cur_code, calc_date, term])
    
    if Rsi.exists?({ :cur_code => cur_code, :calc_date => calc_date, :term => term })
        @Rsi = Rsi.find_by_cur_code_and_calc_date_and_term(cur_code, calc_date, term )
        @Rsi.attributes = {
            :RSI        => sprintf( "%.3f", rsi.first.RSI)
        }
        @Rsi.save!
    else
      Rsi.create!(
          :cur_code  => cur_code,
          :calc_date => calc_date,
          :term      => term,
          :RSI        => sprintf( "%.3f", rsi.first.RSI)
          )
    end
  end  

  def calc_stochastics(cur_code, calc_date, kterm, dterm)
    ##############################################################
    # calc following performance items :                         #
    #     stochastics %K and %D for argument term                #
    ##############################################################
    
    # initialize
    k = 0
    d = 0
    n = 0
    stochastics = Array.new
    startdate = calc_date  
    kdate = startdate
    
    while n < dterm do
      # make some arrays for each terms
      stochasticsK = Array.new
      
      # calc stochastics for indicated term and currencies
      stochasticsK = FxRate.find_by_sql(["select ((A.close_price - B.low)/(B.high - B.low)) as K from fx_rates as A, (
      select X.product_code2 as product_code2, MAX(X.high_price) as high, MIN(X.low_price) as low from (
          select product_code2, high_price, low_price from fx_rates 
          where product_code2 = ?
          and trade_date <= ? 
          order by trade_date desc
          limit ?
          ) as X
      ) as B
      where A.product_code2 = B.product_code2
      and A.trade_date = ?", cur_code, kdate, kterm, kdate])
  
      # if result is nil, set nil to array
      if stochasticsK.empty? then
        stochastics.push(nil)
      else
        stochastics.push(stochasticsK.first.K)       
      end
  
      # increment n
      n = n+1
      wrkdate = (kdate.to_date - 1).strftime("%Y%m%d")        
      wrkweekday = wrkdate.to_date.wday

      case wrkweekday
      when 6 then
        kdate = (wrkdate.to_date - 1).strftime("%Y%m%d")
      when 0 then
        kdate = (wrkdate.to_date - 2).strftime("%Y%m%d")
      else
        kdate = wrkdate        
      end
      
      if kdate.to_date.strftime("%m%d") == '0101'
        kdate = (kdate.to_date - 1).strftime("%Y%m%d") 
      end
           
    end    
    
    # evaluate the value %K and %D
    if stochastics.include?(nil) 
      k = nil
      d = nil
    else
      k = sprintf( "%.3f",stochastics[0])
      d = sprintf( "%.3f",stochastics.inject(0.0){|r,i| r+=i }/stochastics.size)      
    end
    
    if Stochastics.exists?({ :cur_code => cur_code, :calc_date => startdate, :kterm => kterm , :dterm => dterm })
        @stochastics = Stochastics.find_by_cur_code_and_calc_date_and_dterm_and_kterm(cur_code, startdate, dterm , kterm )
        @stochastics.attributes = {
            :K        => k,
            :D        => d
        }
        @stochastics.save!
    else
      Stochastics.create!(
          :cur_code  => cur_code,
          :calc_date => startdate,
          :kterm      => kterm,
          :dterm      => dterm,
          :K        =>  k,
          :D        =>  d
          )
    end
  end

  def calc_difference_from_ma(cur_code, calc_date, term)
    ##############################################################
    # calc following performance items :                         #
    #     difference from moving average                         #
    ##############################################################
    
    # initialize
    difference = Array.new
        
    # calc stochastics for indicated term and currencies
    difference = FxRate.find_by_sql(["select ((A.close_price - B.ma)/B.ma * 100) as DFMA from fx_rates as A, (
    select X.product_code2 as product_code2, AVG(X.close_price) as ma from (
        select product_code2, close_price from fx_rates 
        where product_code2 = ?
        and trade_date <= ?
        order by trade_date desc
        limit ?
        ) as X
    ) as B
    where A.product_code2 = B.product_code2
    and A.trade_date = ?", cur_code, calc_date, term, calc_date])
    
    if difference.empty?
      dfma  = nil
    else
      dfma  = sprintf( "%.3f", difference.first.DFMA)
    end      
  
    if DifferenceFromMa.exists?({ :cur_code => cur_code, :calc_date => calc_date, :term => term})
        @DifferenceFromMa = DifferenceFromMa.find_by_cur_code_and_calc_date_and_term(cur_code, calc_date, term )
        @DifferenceFromMa.attributes = {
            :DFMA        => dfma
        }
        @DifferenceFromMa.save!
    else
      DifferenceFromMa.create!(
          :cur_code  => cur_code,
          :calc_date => calc_date,
          :term      => term,
          :DFMA      => dfma
          )
    end
  end

  def calc_daily_pivot(cur_code, calc_date)
    ##############################################################
    # calc following performance items :                         #
    #     daily pivot                                            #
    ##############################################################
    
    # initialize
    pivot = Array.new
    cycle = 'D'
    
    # settingdigits for computing
    if cur_code[4..6] = 'JPY'
      digits = "%.3f"
    else
      digits = "%.5f"
    end
        
    # calc previous day
    previous_day = (calc_date.to_date - 1).strftime("%Y%m%d")
    wrkweekday = previous_day.to_date.wday    
    case wrkweekday
    when 0 then
      previous_day = (previous_day.to_date - 2).strftime("%Y%m%d")
    when 6 then
      previous_day = (calc_date.to_date - 1).strftime("%Y%m%d")
    end
    
    if previous_day.to_date.strftime("%m%d") == '0101'
     previous_day = (previous_day.to_date - 1).strftime("%Y%m%d") 
    end
    
    # calc stochastics for indicated term and currencies
    pivot = FxRate.find_by_sql(["select C.P, C.R1, C.R2,(C.R1 + (C.high_price - C.low_price)) as R3 , C.S1, C.S2,(C.S1 - (C.high_price - C.low_price)) as S3 from (
      select B.P as P, (B.P+(B.P-B.low_price)) as R1, (B.P+(B.high_price-B.low_price)) as R2, (B.P-(B.high_price-B.P)) as S1, (B.P-(B.high_price-B.low_price)) as S2, B.high_price, B.low_price from fx_rates as A, (
      select X.product_code2 as product_code2, ((X.high_price + X.low_price + X.close_price)/3) as P, X.high_price, X.low_price, X.close_price from (
          select product_code2, high_price, low_price, close_price from fx_rates 
          where product_code2 = ?
          and trade_date = ?
          ) as X
      ) as B
      where A.product_code2 = B.product_code2
      and A.trade_date = ?
      ) as C", cur_code, previous_day, calc_date])
      
    if pivot.empty?
      p  = nil
      r1 = nil
      r2 = nil
      r3 = nil
      s1 = nil
      s2 = nil
      s3 = nil
    else
      p  = sprintf( digits , pivot.first.P)
      r1 = sprintf( digits , pivot.first.R1)
      r2 = sprintf( digits , pivot.first.R2)
      r3 = sprintf( digits , pivot.first.R3)
      s1 = sprintf( digits , pivot.first.S1)
      s2 = sprintf( digits , pivot.first.S2)
      s3 = sprintf( digits , pivot.first.S3)     
    end  
    

    if Pivot.exists?({ :cur_code => cur_code, :calc_date => calc_date, :cycle => cycle})
        @DailyPivot = Pivot.find_by_cur_code_and_calc_date_and_cycle(cur_code, calc_date, cycle )
        @DailyPivot.attributes = {
            :P         => p,
            :R1        => r1,
            :R2        => r2,
            :R3        => r3,
            :S1        => s1,
            :S2        => s2,
            :S3        => s3
        }
        @DailyPivot.save!
    else
      Pivot.create!(
          :cur_code  => cur_code,
          :calc_date => calc_date,
          :cycle     => cycle,
          :P         => p,
          :R1        => r1,
          :R2        => r2,
          :R3        => r3,
          :S1        => s1,
          :S2        => s2,
          :S3        => s3
          )
    end
  end
  

end