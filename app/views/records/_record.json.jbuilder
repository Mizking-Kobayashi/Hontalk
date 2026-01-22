json.extract! record, :id, :user_id, :start_time, :end_time, :library_id, :created_at, :updated_at
json.url record_url(record, format: :json)
