json.array!(@projects) do |project|
  json.extract! project, :id, :title, :description, :category_name, :subcategory_name,:current_state,
    :bid_count, :tags, :skills, :budget, :estimated_time, :location, :buyer_name, :project_start_date, :project_end_date, :buyer_rating,
    :post_messages
  json.url project_url(project, format: :json)
end
