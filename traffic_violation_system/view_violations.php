<?php include 'includes/db.php'; include 'includes/header.php'; ?>
<h3>All Violations</h3>
<table class="table table-dark table-bordered">
  <thead><tr><th>ID</th><th>Vehicle</th><th>Type</th><th>Date</th></tr></thead>
  <tbody>
    <?php
    $res = $conn->query("SELECT * FROM violations LIMIT 20");
    while ($row = $res->fetch_assoc()) {
      echo "<tr><td>{$row['violation_id']}</td><td>{$row['vehicle_no']}</td><td>{$row['violation_type_id']}</td><td>{$row['violation_date']}</td></tr>";
    }
    ?>
  </tbody>
</table>
<?php include 'includes/footer.php'; ?>