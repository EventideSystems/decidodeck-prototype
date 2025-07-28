class Users::InvitationsController < Devise::InvitationsController
  layout "application", only: [ :new ] # NOTE: Defaults to 'devise' layout for other actions

  def create
    user = User.find_by(email: params[:user][:email])

    if user
      if current_account.members.include?(user)
        redirect_to users_path, alert: "A user with the email '#{user.email}' is already a member of this account."
      elsif current_account.max_members_reached?
        redirect_to users_path, alert: "You have reached the maximum number of users for this account."
      else
        AccountMember.create!(user: user, account: current_account)
        redirect_to users_path, notice: "User was successfully invited."
      end
    elsif current_account.max_members_reached?
      redirect_to users_path, alert: "You have reached the maximum number of users for this workspace."
    else
      super do |resource|
        if resource.errors.empty?
          AccountMember.create!(user: resource, account: current_account)
        end
      end
    end
  end

  def new
    self.resource = resource_class.new
    authorize resource, :invite?
    render :new
  end
end
