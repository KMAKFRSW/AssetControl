#encoding: utf-8

module Calculation
  def CalcTermRisk(rates , term)
    # calculate Historical Volatility
    avg = rates.inject(0){|r,i| r+=i.to_f }/term
    variance = rates.inject(0){|r,i| r+=(i.to_f - avg)**2 }/term
    return Math::sqrt(variance)*Math::sqrt(250)
  end
end
