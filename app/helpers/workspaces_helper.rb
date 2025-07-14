module WorkspacesHelper
  def workspace_status_class(workspace)
    case workspace.status
    when "active"
      "bg-green-100 dark:bg-green-900/30 text-green-800 dark:text-green-400"
    when "archived"
      "bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-300"
    when "suspended"
      "bg-yellow-100 dark:bg-yellow-900/30 text-yellow-800 dark:text-yellow-400"
    else
      "bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-300"
    end
  end

  def workspace_type_class(workspace)
    case workspace.workspace_type
    when "project"
      "bg-blue-100 dark:bg-blue-900/30 text-blue-800 dark:text-blue-400"
    when "program"
      "bg-purple-100 dark:bg-purple-900/30 text-purple-800 dark:text-purple-400"
    when "department"
      "bg-indigo-100 dark:bg-indigo-900/30 text-indigo-800 dark:text-indigo-400"
    when "initiative"
      "bg-orange-100 dark:bg-orange-900/30 text-orange-800 dark:text-orange-400"
    when "template"
      "bg-teal-100 dark:bg-teal-900/30 text-teal-800 dark:text-teal-400"
    else
      "bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-300"
    end
  end

  def workspace_type_icon(workspace)
    case workspace.workspace_type
    when "project"
      content_tag(:svg, class: "h-4 w-4 mr-1 inline", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do
        content_tag(:path, "", "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10")
      end
    when "program"
      content_tag(:svg, class: "h-4 w-4 mr-1 inline", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do
        content_tag(:path, "", "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10")
      end
    when "department"
      content_tag(:svg, class: "h-4 w-4 mr-1 inline", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do
        content_tag(:path, "", "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4")
      end
    when "initiative"
      content_tag(:svg, class: "h-4 w-4 mr-1 inline", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do
        content_tag(:path, "", "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M13 10V3L4 14h7v7l9-11h-7z")
      end
    when "template"
      content_tag(:svg, class: "h-4 w-4 mr-1 inline", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do
        content_tag(:path, "", "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z")
      end
    else
      content_tag(:svg, class: "h-4 w-4 mr-1 inline", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do
        content_tag(:path, "", "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10")
      end
    end
  end

  def workspace_card_actions(workspace)
    actions = []

    actions << {
      label: "View",
      url: workspace_path(workspace),
      icon: "eye",
      class: "text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white"
    }

    actions << {
      label: "Edit",
      url: edit_workspace_path(workspace),
      icon: "edit",
      class: "text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white"
    }

    if workspace.active?
      actions << {
        label: "Archive",
        url: workspace_path(workspace),
        method: :delete,
        confirm: "Are you sure you want to archive '#{workspace.name}'?",
        icon: "archive",
        class: "text-red-600 dark:text-red-400 hover:text-red-800 dark:hover:text-red-300"
      }
    end

    actions
  end
end
