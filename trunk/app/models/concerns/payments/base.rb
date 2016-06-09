module Payments
  class Base
    def self.create_debit(attrs, data=nil)
      with_payment_data Debit, attrs, data
    end
    def self.create_credit(attrs, data=nil)
      with_payment_data Credit, attrs, data
    end
    def self.create_referal_bonus(attrs, data=nil)
      with_payment_data ReferalBonus, attrs, data
    end
    private
    def self.with_payment_data(paymentKlass, attrs, data)
      payment = nil
      Payment.transaction do
        payment = paymentKlass.create! klass_attrs(attrs)
        PaymentDetail.create!(payment_id:payment.id, data:data) if data
      end
      payment
    end
    def self.klass_attrs(attrs)
      attrs.merge klass:klass
    end
    protected
    def self.klass
      raise "This class needs to be subclassed" if superclass == Object
      name.split("::").last
    end
  end
end