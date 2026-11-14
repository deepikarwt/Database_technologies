import os

from flask import Flask, flash, redirect, render_template, request, url_for
from pymongo import MongoClient
from pymongo.errors import PyMongoError

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY", "change-this-local-secret")

client = MongoClient(
    os.getenv("MONGODB_URI", "mongodb://localhost:27017/"),
    serverSelectionTimeoutMS=3000,
)
db = client["CollegeDB"]
students = db["students"]


def parse_student_form(include_id=True):
    try:
        student = {
            "name": request.form.get("name", "").strip(),
            "age": int(request.form.get("age", "")),
            "gender": request.form.get("gender", "").strip(),
            "department": request.form.get("department", "").strip(),
            "marks": float(request.form.get("marks", "")),
        }
        if include_id:
            student["student_id"] = request.form.get("student_id", "").strip()
    except ValueError:
        raise ValueError("Age must be a whole number and marks must be numeric.")

    required = ["name", "gender", "department"]
    if include_id:
        required.append("student_id")

    if any(not student[key] for key in required):
        raise ValueError("Please complete all required fields.")

    if student["age"] < 1 or not 0 <= student["marks"] <= 100:
        raise ValueError("Age must be positive and marks must be between 0 and 100.")

    return student


@app.route("/")
def index():
    try:
        count = students.count_documents({})
        connected = True
    except PyMongoError:
        count, connected = 0, False

    return render_template("index.html", count=count, connected=connected)


@app.route("/add", methods=["GET", "POST"])
def add_student():
    if request.method == "POST":
        try:
            student = parse_student_form()

            if students.find_one({"student_id": student["student_id"]}):
                flash("That Student ID is already in use.", "error")
            else:
                students.insert_one(student)
                flash("Student added successfully.", "success")
                return redirect(url_for("view_students"))

        except ValueError as error:
            flash(str(error), "error")
        except PyMongoError:
            flash("Could not save the student. Check that MongoDB is running.", "error")

    return render_template("student_form.html", mode="add", student=None)


@app.route("/students")
def view_students():
    try:
        records = list(students.find().sort("student_id", 1))
    except PyMongoError:
        records = []
        flash("Could not read student records. Check that MongoDB is running.", "error")

    return render_template("students.html", students=records)


@app.route("/search", methods=["GET", "POST"])
def search_student():
    result = None
    searched_id = ""

    if request.method == "POST":
        searched_id = request.form.get("student_id", "").strip()

        if searched_id:
            try:
                result = students.find_one({"student_id": searched_id})
                if result is None:
                    flash("No student found with that ID.", "error")
            except PyMongoError:
                flash("Could not search records. Check that MongoDB is running.", "error")
        else:
            flash("Enter a Student ID to search.", "error")

    return render_template(
        "search.html",
        student=result,
        searched_id=searched_id,
    )


@app.route("/update/<student_id>", methods=["GET", "POST"])
def update_student(student_id):
    try:
        student = students.find_one({"student_id": student_id})
    except PyMongoError:
        flash("Could not read student records. Check that MongoDB is running.", "error")
        return redirect(url_for("view_students"))

    if student is None:
        flash("Student not found.", "error")
        return redirect(url_for("view_students"))

    if request.method == "POST":
        try:
            updated = parse_student_form(include_id=False)
            students.update_one(
                {"_id": student["_id"]},
                {"$set": updated},
            )
            flash("Student updated successfully.", "success")
            return redirect(url_for("view_students"))
        except ValueError as error:
            flash(str(error), "error")
        except PyMongoError:
            flash("Could not update the student. Check that MongoDB is running.", "error")

    return render_template("student_form.html", mode="update", student=student)


@app.route("/delete/<student_id>", methods=["POST"])
def delete_student(student_id):
    try:
        outcome = students.delete_one({"student_id": student_id})
        if outcome.deleted_count:
            flash("Student deleted.", "success")
        else:
            flash("Student not found.", "error")
    except PyMongoError:
        flash("Could not delete the student. Check that MongoDB is running.", "error")

    return redirect(url_for("view_students"))


@app.route("/filters")
def filter_students():
    department = request.args.get("department", "").strip()
    selected = request.args.get("filter", "")
    query = {}

    if selected == "department" and department:
        query = {
            "department": {
                "$regex": f"^{department}$",
                "$options": "i",
            }
        }
    elif selected == "above75":
        query = {"marks": {"$gt": 75}}
    elif selected == "range":
        query = {"marks": {"$gte": 50, "$lte": 80}}
    elif selected == "age":
        query = {"age": {"$gt": 20}}

    try:
        results = list(students.find(query).sort("student_id", 1))
    except PyMongoError:
        results = []
        flash("Could not filter records. Check that MongoDB is running.", "error")

    return render_template(
        "filters.html",
        students=results,
        selected=selected,
        department=department,
    )


if __name__ == "__main__":
    app.run(debug=True)