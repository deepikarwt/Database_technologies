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
db = client["HospitalDB"]
medicines = db["medicines"]

# Store medicine IDs as integers and prevent duplicate IDs.
medicines.create_index("medicine_id", unique=True)


def medicine_form_data():
    """Read and validate the add-medicine form."""
    try:
        medicine = {
            "medicine_id": int(request.form.get("medicine_id", "")),
            "name": request.form.get("name", "").strip(),
            "category": request.form.get("category", "").strip(),
            "price": float(request.form.get("price", "")),
            "stock": int(request.form.get("stock", "")),
            "manufacturer": request.form.get("manufacturer", "").strip(),
        }

        supplier_name = request.form.get("supplier_name", "").strip()
        supplier_phone = request.form.get("supplier_phone", "").strip()
        supplier_city = request.form.get("supplier_city", "").strip()

    except ValueError:
        raise ValueError(
            "Medicine ID and stock must be whole numbers. Price must be numeric."
        )

    if not all(
        medicine[key]
        for key in ("name", "category", "manufacturer")
    ):
        raise ValueError("Please complete all required medicine fields.")

    if medicine["medicine_id"] <= 0:
        raise ValueError("Medicine ID must be a positive number.")
    if medicine["price"] < 0 or medicine["stock"] < 0:
        raise ValueError("Price and stock cannot be negative.")

    # Supplier details are optional, but if any are entered, store all three.
    if supplier_name or supplier_phone or supplier_city:
        if not all((supplier_name, supplier_phone, supplier_city)):
            raise ValueError("Complete all supplier fields or leave them all blank.")
        medicine["supplier"] = {
            "name": supplier_name,
            "phone": supplier_phone,
            "city": supplier_city,
        }

    return medicine


@app.route("/")
def index():
    try:
        total = medicines.count_documents({})
        low_stock_count = medicines.count_documents({"stock": {"$lt": 30}})
        connected = True
    except PyMongoError:
        total = 0
        low_stock_count = 0
        connected = False

    return render_template(
        "index.html",
        total=total,
        low_stock_count=low_stock_count,
        connected=connected,
    )


@app.route("/add", methods=["GET", "POST"])
def add_medicine():
    if request.method == "POST":
        try:
            medicine = medicine_form_data()
            medicines.insert_one(medicine)
            flash("Medicine added successfully.", "success")
            return redirect(url_for("view_medicines"))
        except ValueError as error:
            flash(str(error), "error")
        except PyMongoError:
            flash(
                "Could not add the medicine. Check MongoDB is running "
                "and that the Medicine ID is not already used.",
                "error",
            )

    return render_template("medicine_form.html")


@app.route("/medicines")
def view_medicines():
    sort_by = request.args.get("sort", "medicine_id")
    sort_fields = {
        "medicine_id": "medicine_id",
        "price": "price",
        "stock": "stock",
    }
    field = sort_fields.get(sort_by, "medicine_id")

    try:
        records = list(medicines.find().sort(field, 1))
    except PyMongoError:
        records = []
        flash("Could not read medicines. Check that MongoDB is running.", "error")

    return render_template("medicines.html", medicines=records, sort_by=sort_by)


@app.route("/search", methods=["GET", "POST"])
def search_medicine():
    results = []
    search_value = ""

    if request.method == "POST":
        search_value = request.form.get("search_value", "").strip()

        if not search_value:
            flash("Enter a Medicine ID or medicine name.", "error")
        else:
            try:
                query = {"name": {"$regex": search_value, "$options": "i"}}

                if search_value.isdigit():
                    query = {
                        "$or": [
                            {"medicine_id": int(search_value)},
                            {"name": {"$regex": search_value, "$options": "i"}},
                        ]
                    }

                results = list(medicines.find(query).sort("name", 1))

                if not results:
                    flash("No medicine matched your search.", "error")
            except PyMongoError:
                flash("Could not search. Check that MongoDB is running.", "error")

    return render_template(
        "search.html",
        medicines=results,
        search_value=search_value,
    )


@app.route("/update-stock", methods=["GET", "POST"])
def update_stock():
    updated_medicine = None

    if request.method == "POST":
        try:
            medicine_id = int(request.form.get("medicine_id", ""))
            new_stock = int(request.form.get("new_stock", ""))

            if medicine_id <= 0 or new_stock < 0:
                raise ValueError("Medicine ID must be positive and stock cannot be negative.")

            result = medicines.update_one(
                {"medicine_id": medicine_id},
                {"$set": {"stock": new_stock}},
            )

            if result.matched_count:
                updated_medicine = medicines.find_one({"medicine_id": medicine_id})
                flash("Stock updated successfully.", "success")
            else:
                flash("No medicine found with that Medicine ID.", "error")

        except ValueError as error:
            flash(str(error) or "Enter valid whole numbers.", "error")
        except PyMongoError:
            flash("Could not update stock. Check that MongoDB is running.", "error")

    return render_template("update_stock.html", medicine=updated_medicine)


@app.route("/delete/<int:medicine_id>", methods=["POST"])
def delete_medicine(medicine_id):
    try:
        result = medicines.delete_one({"medicine_id": medicine_id})
        if result.deleted_count:
            flash("Medicine deleted.", "success")
        else:
            flash("Medicine not found.", "error")
    except PyMongoError:
        flash("Could not delete the medicine. Check MongoDB is running.", "error")

    return redirect(url_for("view_medicines"))


@app.route("/filters", methods=["GET", "POST"])
def filter_medicines():
    selected = request.values.get("filter", "")
    value = request.values.get("value", "").strip()
    query = {}
    sort_field = "name"

    try:
        if selected == "category" and value:
            query = {"category": {"$regex": value, "$options": "i"}}
        elif selected == "price_over_50":
            query = {"price": {"$gt": 50}}
        elif selected == "price_under_100":
            query = {"price": {"$lt": 100}}
        elif selected == "low_stock":
            query = {"stock": {"$lt": 30}}
        elif selected == "manufacturer" and value:
            query = {"manufacturer": {"$regex": value, "$options": "i"}}
        elif selected == "sort_price":
            sort_field = "price"
        elif selected == "sort_stock":
            sort_field = "stock"

        records = list(medicines.find(query).sort(sort_field, 1))
    except PyMongoError:
        records = []
        flash("Could not filter medicines. Check that MongoDB is running.", "error")

    return render_template(
        "filters.html",
        medicines=records,
        selected=selected,
        value=value,
    )


@app.route("/report")
def inventory_report():
    try:
        total_medicines = medicines.count_documents({})
        totals = list(
            medicines.aggregate(
                [
                    {
                        "$group": {
                            "_id": None,
                            "total_stock": {"$sum": "$stock"},
                        }
                    }
                ]
            )
        )
        total_stock = totals[0]["total_stock"] if totals else 0

        low_stock = list(medicines.find({"stock": {"$lt": 30}}).sort("stock", 1))
        most_expensive = medicines.find_one(sort=[("price", -1)])
        cheapest = medicines.find_one(sort=[("price", 1)])

    except PyMongoError:
        total_medicines = 0
        total_stock = 0
        low_stock = []
        most_expensive = None
        cheapest = None
        flash("Could not build the report. Check that MongoDB is running.", "error")

    return render_template(
        "report.html",
        total_medicines=total_medicines,
        total_stock=total_stock,
        low_stock=low_stock,
        most_expensive=most_expensive,
        cheapest=cheapest,
    )


if __name__ == "__main__":
    app.run(debug=True)