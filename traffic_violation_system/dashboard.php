<?php include 'includes/db.php'; include 'includes/header.php'; ?>
<h2>Welcome, Officer</h2>
<div class="row">
  <div class="col-md-4">
    <div class="card p-3 shadow">
      <h5>Total Violations</h5>
      <p><?php echo $conn->query("SELECT COUNT(*) FROM violations")->fetch_row()[0]; ?></p>
    </div>
  </div>
  <div class="col-md-4">
    <div class="card p-3 shadow">
      <h5>Pending Payments</h5>
      <p><?php echo $conn->query("SELECT COUNT(*) as count FROM violations WHERE status = 'Unpaid'
")->fetch_row()[0]; ?></p>
<a href="add_violation.php" class="btn">Add Violation</a>
    </div>
  </div>
</div>
<?php include 'includes/footer.php'; ?>