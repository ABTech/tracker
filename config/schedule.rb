every 7.days do
  rake "ts:rebuild"
end

every :hour do
  rake "groupme:notify"
end
