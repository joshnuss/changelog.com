defmodule ChangelogWeb.Admin.PostView do
  use ChangelogWeb, :admin_view

  alias Changelog.{Post, Topic}

  def status_label(post) do
    if post.published do
      content_tag :span, "Published", class: "ui tiny green basic label"
    else
      content_tag :span, "Draft", class: "ui tiny yellow basic label"
    end
  end

  def show_or_preview_path(conn, post) do
    if Post.is_public(post) do
      post_path(conn, :show, post.slug)
    else
      post_path(conn, :preview, post)
    end
  end
end
