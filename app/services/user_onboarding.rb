class UserOnboarding
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :user

  def initialize(user:)
    @user = user
    @account = nil
    @workspace = nil
    @welcome_artifact = nil
  end

  def call
    ActiveRecord::Base.transaction do
      create_account!
      create_workspace!
      create_welcome_artifact!

      Result.new(
        success: true,
        account: @account,
        workspace: @workspace,
        welcome_artifact: @welcome_artifact
      )
    end
  rescue => error
    Rails.logger.error "User onboarding failed for user #{@user.id}: #{error.message}"
    Result.new(
      success: false,
      error: error,
      message: "Failed to set up your account. Please try again or contact support."
    )
  end

  private

  attr_reader :user

  def create_account!
    @account = Account.create!(
      name: "#{user.display_name}'s Account",
      owner: user
    )
    Rails.logger.info "Created account #{@account.id} for user #{user.id}"
  end

  def create_workspace!
    @workspace = Workspace.create!(
      name: "Default Workspace",
      description: "Your first workspace to get started",
      account: @account
    )
    Rails.logger.info "Created workspace #{@workspace.id} for user #{user.id}"
  end

  def create_welcome_artifact!
    welcome_content = ArtifactContent::Note.create!(
      title: "Welcome to Decidodeck!",
      owner: user,
      markdown: welcome_markdown
    )

    @welcome_artifact = Artifact.create!(
      workspace: @workspace,
      content: welcome_content,
      tags: [ "welcome", "getting-started" ]
    )
    Rails.logger.info "Created welcome artifact #{@welcome_artifact.id} for user #{user.id}"
  end

  def welcome_markdown
    <<~MARKDOWN
      # Welcome to Decidodeck! 🎉

      We're excited to have you on board. Here's what we've set up for you:

      ## Your Account
      - **Account Name**: #{@account.name}
      - **Workspace**: #{@workspace.name}

      ## Getting Started
      - [ ] Explore your workspace
      - [ ] Create your first artifact
      - [ ] Invite team members
      - [ ] Set up your profile

      ## Quick Tips
      - Use **markdown** to format your content
      - Create task lists with `- [ ]` and `- [x]`
      - Tag your artifacts for easy organization

      Happy deciding! 🚀
    MARKDOWN
  end

  # Result object for clean return values
  class Result
    attr_reader :account, :workspace, :welcome_artifact, :error, :message

    def initialize(success:, account: nil, workspace: nil, welcome_artifact: nil, error: nil, message: nil)
      @success = success
      @account = account
      @workspace = workspace
      @welcome_artifact = welcome_artifact
      @error = error
      @message = message
    end

    def success?
      @success
    end

    def failure?
      !@success
    end
  end
end
