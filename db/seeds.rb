# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# employee = Employee.create() #to create db entry of employee in employee table but we paste in concole after rails c command to open console
#  in cmd and this command
# employee = Employee.new    #second step to create entry not insert in employee table
# employee.save # insert by this query

#to insert data in db 

#   employee =Employee.create(first_name: "hassan", last_name:"Nadeem", personal_email:"hassan@gmail.com", city:"Sahiwal", state:"Punjab",
#   country:"Pakistan", pincode:"57000", address_line_1:"jeewan city" )
  
# employee.save #to insert above data in db


