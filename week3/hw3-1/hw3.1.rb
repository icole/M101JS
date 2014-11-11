require 'mongo'

students = Mongo::MongoClient.new("localhost", 27017).db("school").collection("students")
students.find.each do |student|
  sorted_scores = student["scores"].select{|s| s["type"] == "homework"}.sort_by{|s| s["score"]}
  lowest_score = sorted_scores[0]["score"]
  new_scores = student["scores"].reject{|s| s["score"] == lowest_score}
  students.update({"_id" => student["_id"]}, {"$set" => {"scores" => new_scores}})
end
