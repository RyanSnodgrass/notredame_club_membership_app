json.array!(@clubs) do |club|
  json.extract! club, :id, :name, :description, :accepting
  json.url club_url(club, format: :json)
end
