class ArtifactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workspace
  before_action :set_artifact, only: [ :show, :edit, :update, :destroy ]

  def index
    @artifacts = @workspace.artifacts.includes(:content)
  end

  def show
    # The view will handle different content types
  end

  def new
    @content_type = params[:content_type] || "ArtifactContent::Note"
    @artifact = @workspace.artifacts.build

    case @content_type
    when "ArtifactContent::Note"
      @content = ArtifactContent::Note.new
    else
      redirect_to workspace_artifacts_path(@workspace), alert: "Invalid content type"
      nil
    end
  end

  def create
    @content_type = params[:content_type] || "ArtifactContent::Note"

    ActiveRecord::Base.transaction do
      case @content_type
      when "ArtifactContent::Note"
        @content = ArtifactContent::Note.new(note_params)
        @content.owner = current_user
        @content.save!

        @artifact = @workspace.artifacts.build(artifact_params)
        @artifact.content = @content
        @artifact.save!

        redirect_to [ @workspace, @artifact ], notice: "Artifact was successfully created."
      else
        redirect_to workspace_artifacts_path(@workspace), alert: "Invalid content type"
      end
    end
  rescue ActiveRecord::RecordInvalid
    case @content_type
    when "ArtifactContent::Note"
      @content = ArtifactContent::Note.new(note_params)
    end
    @artifact = @workspace.artifacts.build(artifact_params)
    render :new, status: :unprocessable_entity
  end

  def edit
    # The view will handle different content types based on @artifact.content
  end

  def update
    ActiveRecord::Base.transaction do
      case @artifact.content
      when ArtifactContent::Note
        @artifact.content.update!(note_params)
        @artifact.update!(artifact_params)
        redirect_to [ @workspace, @artifact ], notice: "Artifact was successfully updated."
      else
        redirect_to [ @workspace, @artifact ], alert: "Unsupported content type for editing"
      end
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @artifact.discard
    redirect_to workspace_artifacts_path(@workspace), notice: "Artifact was successfully deleted."
  end

  def toggle_task
    content_type = params[:content_type]
    task_index = params[:task_index].to_i
    checked = params[:checked]

    case content_type
    when "ArtifactContent::Note"
      if @artifact.content.is_a?(ArtifactContent::Note)
        updated_markdown = toggle_task_in_markdown(@artifact.content.markdown, task_index, checked)
        @artifact.content.update!(markdown: updated_markdown)
        render json: { success: true }
      else
        render json: { error: "Invalid content type" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Unsupported content type" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_workspace
    @workspace = current_account.workspaces.find(params[:workspace_id])
  end

  def set_artifact
    @artifact = @workspace.artifacts.find(params[:id])
  end

  def artifact_params
    params.require(:artifact).permit(tags: [])
  end

  def note_params
    params.require(:artifact_content_note).permit(:title, :markdown)
  end

  def toggle_task_in_markdown(markdown_text, task_index, checked)
    lines = markdown_text.split("\n")
    task_count = 0

    lines.map do |line|
      if line.match(/^\s*-\s+\[([ x])\]\s+/)
        if task_count == task_index
          if checked
            line.sub(/\[([ ])\]/, "[x]")
          else
            line.sub(/\[x\]/, "[ ]")
          end
        else
          line
        end.tap { task_count += 1 }
      else
        line
      end
    end.join("\n")
  end
end
