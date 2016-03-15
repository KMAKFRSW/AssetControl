#encoding: utf-8

module Calculation
  def StDev(rates , term)
    # calculate Annual Historical Volatility 
    avg = rates.inject(0){|r,i| r+=i.to_f }/term
    variance = rates.inject(0){|r,i| r+=(i.to_f - avg)**2 }/term
    return Math::sqrt(variance)
  end
end
