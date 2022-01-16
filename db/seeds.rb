# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

default_location = Location.find_or_initialize_by(id: 0)
default_location.building = '!N/A'
default_location.room = 'Not Available/Applicable'
default_location.details = 'For new event requests.'
default_location.save!(validate: false)

default_organization = Organization.find_or_initialize_by(id: 0)
default_organization.name = '!unset'
default_organization.save!(validate: false)
