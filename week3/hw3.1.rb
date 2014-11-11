require 'mongo'

students = Mongo::MongoClient.new("localhost", 27017).db("school").collection("students")
students.find.each do |student|
  lowest_score = student["scores"].select{|s| s["type"] == "homework"}.sort_by{|s| s["score"]}[0]["score"]
  new_scores = student["scores"].reject{|s| s["score"] == lowest_score}
  students.update({"_id" => student["_id"]}, {"$set" => {"score" => new_scores}})
end
