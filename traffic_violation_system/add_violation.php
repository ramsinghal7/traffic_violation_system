<?php
include('includes/db.php');

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $vehicle_id = $_POST['vehicle_id'];
    $plate_number = $_POST['plate_number'];
    $vehicle_type = $_POST['vehicle_type'];
    $model = $_POST['model'];
    $owner_id = $_POST['owner_id'];

    $officer_id = $_POST['officer_id'];
    $violation_type_id = $_POST['violation_type_id'];
    $location_id = $_POST['location_id'];
    $violation_date = $_POST['violation_date'];
    $status = 'Unpaid';

    // If vehicle is not selected (new vehicle to be inserted)
    if ($vehicle_id == 'new') {
        $insert_vehicle = $conn->prepare("INSERT INTO vehicles (plate_number, vehicle_type, model, owner_id) VALUES (?, ?, ?, ?)");
        $insert_vehicle->bind_param("sssi", $plate_number, $vehicle_type, $model, $owner_id);
        $insert_vehicle->execute();
        $vehicle_id = $conn->insert_id;
    }

    // Insert violation
    $insert_violation = $conn->prepare("INSERT INTO violations (vehicle_id, officer_id, violation_type_id, location_id, violation_date, status)
                                        VALUES (?, ?, ?, ?, ?, ?)");
    $insert_violation->bind_param("iiiiss", $vehicle_id, $officer_id, $violation_type_id, $location_id, $violation_date, $status);

    if ($insert_violation->execute()) {
        echo "<script>alert('Violation Added Successfully'); window.location.href='dashboard.php';</script>";
    } else {
        echo "Error: " . $insert_violation->error;
    }
}

// Fetch data for dropdowns
$vehicles_result = $conn->query("SELECT vehicle_id, plate_number FROM vehicles");
$violation_types_result = $conn->query("SELECT violation_type_id, violation_name FROM violation_types");
$locations_result = $conn->query("SELECT location_id, CONCAT(area_name, ', ', city) AS location_name FROM location");
?>

<!DOCTYPE html>
<html>
<head>
    <title>Add Traffic Violation</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background-color: #121212;
            color: #f1f1f1;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .form-container {
            background-color: #1e1e1e;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.5);
            width: 100%;
            max-width: 600px;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #00d9ff;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            margin-top: 18px;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 5px;
            border: 1px solid #444;
            background-color: #2a2a2a;
            color: #f1f1f1;
            border-radius: 8px;
            transition: 0.2s ease;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #00d9ff;
            background-color: #2e2e2e;
        }

        .btn {
            background-color: #00d9ff;
            color: #000;
            font-weight: bold;
            padding: 12px;
            margin-top: 20px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            width: 100%;
            transition: background 0.3s ease;
        }

        .btn:hover {
            background-color: #00aacc;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Add Traffic Violation</h2>
    <form method="post" action="">
        <label>Select Vehicle:</label>
        <select name="vehicle_id" required>
            <option value="">-- Select Existing Vehicle --</option>
            <?php while ($row = $vehicles_result->fetch_assoc()) { ?>
                <option value="<?= $row['vehicle_id'] ?>"><?= $row['plate_number'] ?></option>
            <?php } ?>
            <option value="new">Add New Vehicle</option>
        </select>

        <label>Plate Number:</label>
        <input type="text" name="plate_number">

        <label>Vehicle Type:</label>
        <input type="text" name="vehicle_type">

        <label>Model:</label>
        <input type="text" name="model">

        <label>Owner ID:</label>
        <input type="number" name="owner_id">

        <label>Officer ID:</label>
        <input type="number" name="officer_id" required>

        <label>Violation Type:</label>
        <select name="violation_type_id" required>
            <option value="">-- Select Violation Type --</option>
            <?php while ($row = $violation_types_result->fetch_assoc()) { ?>
                <option value="<?= $row['violation_type_id'] ?>"><?= $row['violation_name'] ?></option>
            <?php } ?>
        </select>

        <label>Location:</label>
        <select name="location_id" required>
            <option value="">-- Select Location --</option>
            <?php while ($row = $locations_result->fetch_assoc()) { ?>
                <option value="<?= $row['location_id'] ?>"><?= $row['location_name'] ?></option>
            <?php } ?>
        </select>

        <label>Violation Date:</label>
        <input type="datetime-local" name="violation_date" required>

        <input type="submit" value="Add Violation" class="btn">
    </form>
</div>
</body>
</html>