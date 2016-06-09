ActiveAdmin.register ReferralMembers do


  menu :parent => "Users",:label => "Referrals"
  actions  :index

  filter :first_name_cont, label: 'First Name'
  filter :last_name_cont, label: 'Last Name'
  filter :phone_cont, label: 'Phone Number'
  filter :email_cont, label: 'Email'

    index title: "Referrals" do
      column :first_name
      column :last_name
      column :role_name
      column "Referred By" do |user|
        user.referral_full_name
      end
      column "Source" do |user|
        user.referral_source
      end
      column "Bonus" do |user|
        if user.buyer?
          if user.referral_bonus != true
            "-"
          else
            "$10"
          end
        else
          if user.confirmed?
            "10 connects"
          else
            "-"
          end
        end
      end
    end

    controller do
      def scoped_collection
        User.referral_members
      end
    end

    csv do
      column :first_name
      column :last_name
      column :role_name
      column "Referred By" do |user|
        user.referral_full_name
      end
      column "Source" do |user|
        user.referral_source
      end
      column "Bonus" do |user|
        if user.buyer?
          if user.referral_bonus != true
            "-"
          else
            "$10"
          end
        else
          if user.confirmed?
            "10 connects"
          else
            "-"
          end
        end
      end
    end
end
