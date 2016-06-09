ActiveAdmin.register PaymentType do

  menu :parent => "Payment Module",:label => "Payment Settings"

  permit_params :display_name, :active
  config.filters = false
  index :download_links=>false do
    selectable_column
    id_column
    column :name
    column :display_name
    column :active
    column :actions do |resource|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to "Make #{!resource.active ? 'Activate' : 'Deactivate'}", make_active_inactive_admin_payment_type_path(resource), :method => :put, :class => "member_link"
      links += link_to "Set Settings", "/admin/payment_settings/#{resource.payment_setting.id}/edit", :class => "member_link" if resource.payment_setting
      links
    end
  end

  form do |f|
    f.inputs "Payment Modules" do
      f.input :display_name
      f.input :active
    end
    f.actions
  end

  member_action :make_active_inactive, :method => :put do
    payment = PaymentType.find(params[:id])
    if payment.active
      payment.update_attribute(:active,false)
      flash[:notice] = "Payment Module deactivated."
    else
      payment.update_attribute(:active,true)
      flash[:notice] = "Payment Module activated."
    end
    redirect_to :back
  end

  controller do
    def update
      update! do |format|
        format.html { redirect_to admin_payment_types_path }
      end
    end
  end
 csv do
  
 end
end
